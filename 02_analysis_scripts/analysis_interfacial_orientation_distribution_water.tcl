# Load structure and trajectories
mol new wat_graphene_nacl.psf
mol addfile wat_graphene_nacl_prod_1.dcd first 0 last -1 step 1 waitfor -1
mol addfile wat_graphene_nacl_prod_2.dcd first 0 last -1 step 1 waitfor -1
mol addfile wat_graphene_nacl_prod_3.dcd first 0 last -1 step 1 waitfor -1
mol addfile wat_graphene_nacl_prod_4.dcd first 0 last -1 step 1 waitfor -1
mol addfile wat_graphene_nacl_prod_5.dcd first 0 last -1 step 1 waitfor -1

# Find the number of frames
set nf [molinfo top get numframes]

# Define the interfacial solvent layer
set zmax 4.7

# Define bin width for cos(theta)
set dcos 0.05
set nCosBins [expr {int(2.0 / $dcos)}]

# Variables
set cosSum 0.0
set totalWaters 0
set countTotal [lrepeat $nCosBins 0]

# Loop over all frames
for {set j 0} {$j < $nf} {incr j} {

    # Select water molecules in the interfacial solvent layer
    set solvO [atomselect top "name OH2 and x > -50.0 and x < 50.0 and y > -50.0 and y < 50.0 and z > -$zmax and z < $zmax" frame $j]
    set solvH1 [atomselect top "name H1 and same residue as (name OH2 and x > -50.0 and x < 50.0 and y > -50.0 and y < 50.0 and z > -$zmax and z < $zmax)" frame $j]
    set solvH2 [atomselect top "name H2 and same residue as (name OH2 and x > -50.0 and x < 50.0 and y > -50.0 and y < 50.0 and z > -$zmax and z < $zmax)" frame $j]

    set numO [$solvO num]

    if {$numO > 0} {

        set Ocoords  [$solvO get {x y z}]
        set H1coords [$solvH1 get {x y z}]
        set H2coords [$solvH2 get {x y z}]

        foreach O $Ocoords H1 $H1coords H2 $H2coords {

            set OH1 [vecsub $H1 $O]
            set OH2 [vecsub $H2 $O]
            set dipole [vecadd $OH1 $OH2]
            set dipoleUnit [vecnorm $dipole]

            set zO [lindex $O 2]

            if {$zO > 0.0} {
                set normal {0.0 0.0 1.0}
            } else {
                set normal {0.0 0.0 -1.0}
            }

            set cosTheta [vecdot $dipoleUnit $normal]

            set cosSum [expr {$cosSum + $cosTheta}]
            incr totalWaters

            set bin [expr {int(($cosTheta + 1.0) / $dcos)}]

            # Protect against round-off at cos(theta) = +/-1
            if {$bin < 0} {
                set bin 0
            }
            if {$bin >= $nCosBins} {
                set bin [expr {$nCosBins - 1}]
            }

            lset countTotal $bin [expr {[lindex $countTotal $bin] + 1}]

            unset OH1
            unset OH2
            unset dipole
            unset dipoleUnit
            unset zO
            unset normal
            unset cosTheta
            unset bin
        }

        unset Ocoords
        unset H1coords
        unset H2coords
    }

    $solvO delete
    $solvH1 delete
    $solvH2 delete

    unset solvO
    unset solvH1
    unset solvH2
    unset numO
}

set probList {}

if {$totalWaters > 0} {

    foreach count $countTotal {
        set prob [expr {double($count) / double($totalWaters)}]
        lappend probList $prob
        unset prob
    }

} else {

    set probList [lrepeat $nCosBins 0.0]
}

set outDist [open "interfacial_orientation_distribution.csv" w]
puts $outDist "cosTheta,probability,count"

for {set k 0} {$k < $nCosBins} {incr k} {

    set cosLower [expr {-1.0 + $k * $dcos}]
    set cosCentre [expr {$cosLower + 0.5 * $dcos}]
    set prob [lindex $probList $k]
    set count [lindex $countTotal $k]

    puts $outDist "$cosCentre,$prob,$count"

    unset cosLower
    unset cosCentre
    unset prob
    unset count
}

close $outDist

unset nf
unset zmax
unset dcos
unset nCosBins
unset cosSum
unset totalWaters
unset countTotal
unset cosAvg
unset probList
unset -nocomplain prob
unset outDist

quit
