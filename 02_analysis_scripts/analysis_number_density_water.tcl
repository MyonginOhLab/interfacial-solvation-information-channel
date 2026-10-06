# Function for calculating the average
proc average {data} {
    set sum 0.0
    foreach value $data {
        set sum [expr {$sum + $value}]
    }
    return [expr {$sum / [llength $data]}]
}

# Load structure and trajectories
mol new wat_graphene_nacl.psf
mol addfile wat_graphene_nacl_prod_1.dcd first 0 last -1 step 1 waitfor -1
mol addfile wat_graphene_nacl_prod_2.dcd first 0 last -1 step 1 waitfor -1
mol addfile wat_graphene_nacl_prod_3.dcd first 0 last -1 step 1 waitfor -1
mol addfile wat_graphene_nacl_prod_4.dcd first 0 last -1 step 1 waitfor -1
mol addfile wat_graphene_nacl_prod_5.dcd first 0 last -1 step 1 waitfor -1

# Find the number of frames
set nf [molinfo top get numframes]

# Define slab dimensions (10 nm x 10 nm x 0.01 nm)
set lx 100.0
set ly 100.0
set dz 0.1

# Combine the +z and -z slabs
set vslab [expr {2.0 * $lx * $ly * $dz}]

# Output file
set out [open "analysis_number_density.csv" w]
puts $out "z(A),rho(nm^-3)"

# z = 0 to 20 A, with 0.1 A bins
for {set i 0} {$i < 200} {incr i} {

    set zi [expr {$i * $dz}]
    set zf [expr {$zi + $dz}]

    set denOList {}

    for {set j 0} {$j < $nf} {incr j} {

        set solv [atomselect top "name OH2 and x > -50 and x < 50 and y > -50 and y < 50 and ((z > $zi and z < $zf) or (z < -$zi and z > -$zf))" frame $j]
        set numO [$solv num]
        set denO [expr {double($numO) / $vslab * 1000}]
        lappend denOList $denO

        $solv delete
        unset solv
        unset numO
        unset denO
    }

    set denOavg [average $denOList]
    set zcentre [expr {$zi + 0.5 * $dz}]
    puts $out "$zcentre,$denOavg"

    unset denOList
    unset denOavg
    unset zcentre
    unset zi
    unset zf
}

close $out

unset nf
unset lx
unset ly
unset dz
unset vslab
unset out