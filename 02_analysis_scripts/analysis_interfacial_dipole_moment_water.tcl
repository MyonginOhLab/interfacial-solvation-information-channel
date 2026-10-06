proc mean_std {values} {
    set n [llength $values]

    if {$n == 0} {
        error "input list is empty"
    }

    # Mean
    set sum 0.0
    foreach x $values {
        set sum [expr {$sum + double($x)}]
    }
    set mean [expr {$sum / double($n)}]

    # Sample standard deviation
    if {$n == 1} {
        set std 0.0
    } else {
        set ss 0.0
        foreach x $values {
            set dx [expr {double($x) - $mean}]
            set ss [expr {$ss + $dx*$dx}]
        }
        set std [expr {sqrt($ss / double($n - 1))}]
    }

    return [list $mean $std]
}

# Conversion factor: 1 e*A = 4.80320471257 Debye
set eA_to_D 4.80320471257

# Load structure and trajectories
mol new wat_graphene_nacl.psf
mol addfile wat_graphene_nacl_prod_1.dcd first 0 last -1 step 1 waitfor -1
mol addfile wat_graphene_nacl_prod_2.dcd first 0 last -1 step 1 waitfor -1
mol addfile wat_graphene_nacl_prod_3.dcd first 0 last -1 step 1 waitfor -1
mol addfile wat_graphene_nacl_prod_4.dcd first 0 last -1 step 1 waitfor -1
mol addfile wat_graphene_nacl_prod_5.dcd first 0 last -1 step 1 waitfor -1

# Number of frames
set nf [molinfo top get numframes]

# Define the interfacial solvent layer
set zmax 4.7

# Store the dipole moment (D)
set dipoleList {}

for {set j 0} {$j < $nf} {incr j} {

    set interfacialSel "name OH2 and x > -50.0 and x < 50.0 and y > -50.0 and y < 50.0 and z > -$zmax and z < $zmax"

    set solvO  [atomselect top $interfacialSel frame $j]
    set solvH1 [atomselect top "name H1 and same residue as ($interfacialSel)" frame $j]
    set solvH2 [atomselect top "name H2 and same residue as ($interfacialSel)" frame $j]

    set numO [$solvO num]

    if {$numO > 0} {

        # Coordinates (in A)
        set Ocoords  [$solvO  get {x y z}]
        set H1coords [$solvH1 get {x y z}]
        set H2coords [$solvH2 get {x y z}]

        # Partial charges (in e)
        set qOlist  [$solvO  get charge]
        set qH1list [$solvH1 get charge]
        set qH2list [$solvH2 get charge]

        foreach O $Ocoords H1 $H1coords H2 $H2coords qO $qOlist qH1 $qH1list qH2 $qH2list {

            # Use the oxygen position as the reference origin
            set OH1 [vecsub $H1 $O]
            set OH2 [vecsub $H2 $O]

            set muH1 [vecscale $qH1 $OH1]
            set muH2 [vecscale $qH2 $OH2]
            set dipole_eA [vecadd $muH1 $muH2]

            set dipoleMag_eA [veclength $dipole_eA]

            set dipoleMag_D [expr {$dipoleMag_eA * $eA_to_D}]

            lappend dipoleList $dipoleMag_D
        }
    }

    $solvO delete
    $solvH1 delete
    $solvH2 delete

    if {[expr {$j % 100}] == 0} {
        puts "Processed frame $j / $nf"
    }
}

# Calculate mean and standard deviation
lassign [mean_std $dipoleList] averageDipole stdDipole
set nSamples [llength $dipoleList]

# Write analysis summary to csv
set outDipole [open "average_interfacial_dipole_moment.csv" w]
puts $outDipole "average_dipole_D,standard_deviation_D,n_samples"
puts $outDipole [format "%.8f,%.8f,%d" $averageDipole $stdDipole $nSamples]
close $outDipole

unset dipoleList
unset averageDipole
unset stdDipole
unset nSamples
unset nf
unset zmax
unset eA_to_D
unset -nocomplain interfacialSel

quit
