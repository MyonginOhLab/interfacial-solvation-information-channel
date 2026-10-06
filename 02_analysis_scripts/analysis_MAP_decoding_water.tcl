# Load structure and trajectories for ONE known surface-sign condition.
mol new wat_graphene_nacl.psf
mol addfile wat_graphene_nacl_prod_1.dcd first 0 last -1 step 1 waitfor -1
mol addfile wat_graphene_nacl_prod_2.dcd first 0 last -1 step 1 waitfor -1
mol addfile wat_graphene_nacl_prod_3.dcd first 0 last -1 step 1 waitfor -1
mol addfile wat_graphene_nacl_prod_4.dcd first 0 last -1 step 1 waitfor -1
mol addfile wat_graphene_nacl_prod_5.dcd first 0 last -1 step 1 waitfor -1

# True charge sign of the surface: "positive" or "negative"
set trueSign "positive"

# Prior probability
set pi 0.5

# Error probabilities
set alpha 0.20634547
set beta 0.171536783

# Define interfacial solvent
set zmax 4.7

# x/y bounds
set xmin -50.0
set xmax  50.0
set ymin -50.0
set ymax  50.0

# Number of molecules observed by the decoder
set listN {1 2 4 6 8 10 12 14 16 18 20 25 30 35 40 45 50 55 60}

# Number of independent random subsets sampled for each frame and N
set nRepeat 10

# Analyze every frame (frequency)
set frameStride 1

# Set random number seed
set randomSeed 12376
expr {srand($randomSeed)}

# Output files names
set rawOutput     "analysis_MAP_decoding_water_raw.csv"
set summaryOutput "analysis_MAP_decoding_water_summary.csv"

# Sample N elements without replacement
proc sample_without_replacement {inputList n} {
    set pool $inputList
    set selected {}

    if {$n > [llength $pool]} {
        return {}
    }

    for {set i 0} {$i < $n} {incr i} {
        set idx [expr {int(rand() * [llength $pool])}]
        lappend selected [lindex $pool $idx]
        set pool [lreplace $pool $idx $idx]
    }

    return $selected
}

set molid [molinfo top]
set nf [molinfo $molid get numframes]

set outRaw [open $rawOutput w]
puts $outRaw "frame,N,repeat,K,fraction_up,lambda,posterior_positive,predicted_sign,true_sign,correct_score"

# Accumulators for summary statistics versus N.
array set totalCount {}
array set correctScoreSum {}
array set posteriorTrueSum {}
array set lambdaSum {}

foreach nn $listN {
    set totalCount($nn) 0
    set correctScoreSum($nn) 0.0
    set posteriorTrueSum($nn) 0.0
    set lambdaSum($nn) 0.0
}

# Constant part of the MAP log-posterior odds
set logPriorOdds [expr {log($pi / (1.0 - $pi))}]
set logUpLR      [expr {log((1.0 - $beta) / $alpha)}]
set logDownLR    [expr {log($beta / (1.0 - $alpha))}]


for {set j 0} {$j < $nf} {incr j $frameStride} {

    set solvO [atomselect $molid "name OH2 and x > $xmin and x < $xmax and y > $ymin and y < $ymax and z > -$zmax and z < $zmax"]
    $solvO frame $j
    $solvO update

    set residListIni [$solvO get residue]
    set residListFin [lsort -unique -integer -increasing $residListIni]
    $solvO delete

    array unset Y
    set validResidues {}

    foreach rr $residListFin {

        set selO  [atomselect $molid "name OH2 and residue $rr"]
        set selH1 [atomselect $molid "name H1 and residue $rr"]
        set selH2 [atomselect $molid "name H2 and residue $rr"]

        foreach sel [list $selO $selH1 $selH2] {
            $sel frame $j
            $sel update
        }

        set coordO  [lindex [$selO  get {x y z}] 0]
        set coordH1 [lindex [$selH1 get {x y z}] 0]
        set coordH2 [lindex [$selH2 get {x y z}] 0]

        # Delete selections immediately after extracting coordinates.
        foreach sel [list $selO $selH1 $selH2] {
            $sel delete
        }

        set OH1 [vecsub $coordH1 $coordO]
        set OH2 [vecsub $coordH2 $coordO]
        set dipole [vecadd $OH1 $OH2]

        set dipoleMag [veclength $dipole]
        if {$dipoleMag <= 1.0e-12} {
            continue
        }

        set dipoleUnit [vecscale [expr {1.0 / $dipoleMag}] $dipole]

        set zO [lindex $coordO 2]
        if {$zO > 0.0} {
            set normal {0.0 0.0 1.0}
        } else {
            set normal {0.0 0.0 -1.0}
        }

        set cosTheta [vecdot $dipoleUnit $normal]

        if {$cosTheta > 0.0} {
            set Y($rr) 1
        } else {
            set Y($rr) 0
        }

        lappend validResidues $rr
    }

    set nAvailable [llength $validResidues]

    # MAP decoding for each requested observation size N
    foreach nn $listN {

        if {$nAvailable < $nn} {
            continue
        }

        for {set rep 1} {$rep <= $nRepeat} {incr rep} {

            set selected [sample_without_replacement $validResidues $nn]
            if {[llength $selected] != $nn} {
                continue
            }

            # K = number of sampled water molecules with Y=1 (up orientation)
            set K 0
            foreach rr $selected {
                incr K $Y($rr)
            }

            set fractionUp [expr {double($K) / double($nn)}]

            # MAP log-posterior odds
            set lambda [expr {$logPriorOdds + $K * $logUpLR + ($nn - $K) * $logDownLR}]

            # MAP decision
            if {$lambda > 0.0} {
                set predictedSign "positive"
                if {$trueSign eq "positive"} {
                    set correctScore 1.0
                } else {
                    set correctScore 0.0
                }
            } elseif {$lambda < 0.0} {
                set predictedSign "negative"
                if {$trueSign eq "negative"} {
                    set correctScore 1.0
                } else {
                    set correctScore 0.0
                }
            } else {
                set predictedSign "tie"
                set correctScore 0.5
            }

            if {$trueSign eq "positive"} {
                set posteriorTrue $posteriorPositive
            } else {
                set posteriorTrue [expr {1.0 - $posteriorPositive}]
            }

            puts $outRaw "$j,$nn,$rep,$K,$fractionUp,$lambda,$posteriorPositive,$predictedSign,$trueSign,$correctScore"

            incr totalCount($nn)
            set correctScoreSum($nn) [expr {$correctScoreSum($nn) + $correctScore}]
            set posteriorTrueSum($nn) [expr {$posteriorTrueSum($nn) + $posteriorTrue}]
            set lambdaSum($nn) [expr {$lambdaSum($nn) + $lambda}]
        }
    }

    array unset Y

    if {$j % 100 == 0} {
        puts "Processed frame $j / [expr {$nf - 1}] ; valid interfacial water = $nAvailable"
    }
}

close $outRaw

set outSummary [open $summaryOutput w]
puts $outSummary "N,n_decoding_events,accuracy,error_probability,mean_posterior_true_sign,mean_lambda"

foreach nn $listN {
    if {$totalCount($nn) > 0} {
        set accuracy [expr {$correctScoreSum($nn) / double($totalCount($nn))}]
        set errorProbability [expr {1.0 - $accuracy}]
        set meanPosteriorTrue [expr {$posteriorTrueSum($nn) / double($totalCount($nn))}]
        set meanLambda [expr {$lambdaSum($nn) / double($totalCount($nn))}]

        puts $outSummary "$nn,$totalCount($nn),$accuracy,$errorProbability,$meanPosteriorTrue,$meanLambda"
    } else {
        puts $outSummary "$nn,0,NA,NA,NA,NA"
    }
}

close $outSummary

quit
