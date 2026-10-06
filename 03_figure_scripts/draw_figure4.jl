using CairoMakie

sigma = ["0.05", "0.10", "0.20"]
materials = ["H₂O", "MeCN", "MeOH", "EtOH", "PrOH", "DMSO"]
x = 1:length(materials)

I₁ = [0.037453137 0.130243651 0.134474759 0.240275064 0.278595475 0.131433957;
 0.135601406 0.360387331 0.425772987 0.553712255 0.604687256 0.456917112;
 0.392954995 0.553216788 0.790870753 0.807440688 0.856930486 0.863055786]

I₂ = [0.024177764 0.095330768 0.10585737 0.186791942 0.216675378 0.092130886;
 0.093135572 0.286936992 0.355233483 0.470068809 0.516081659 0.366007501;
 0.301302226 0.438021717 0.721576712 0.74162547 0.784311406 0.845482119]

Rᵢ = [64.55470998 73.19417662 78.71913681 77.74087712 77.77419138 70.09671471;
 68.68333779 79.61905653 83.43260227 84.89405898 85.34687214 80.10369747;
 76.67601381 79.1772278 91.23825967 91.84890999 91.52567433 97.96378545]

fig = Figure(size=(600,1000))

ax1 = Axis(fig[1,1], ylabel="I(S;Y) (bits)", xticks=(x,materials), limits = (0.5,6.5,0.0,1.0), yticks=0.0:0.25:1.0, titlesize=30, xlabelsize=28, ylabelsize=28, xticklabelsize=25, yticklabelsize=25)

scatterlines!(ax1, x, I₂[1,:]; color=:indianred, linestyle=:dash, linewidth=4, marker=:circle, markersize=20, strokecolor=:black, strokewidth=1.5, label="|σ| = 0.05 (C/m²)")
scatterlines!(ax1, x, I₂[2,:]; color=:springgreen2, linestyle=:dash, linewidth=4, marker=:circle, markersize=20, strokecolor=:black, strokewidth=1.5, label="|σ| = 0.10 (C/m²)")
scatterlines!(ax1, x, I₂[3,:]; color=:dodgerblue, linestyle=:dash, linewidth=4, marker=:circle, markersize=20, strokecolor=:black, strokewidth=1.5, label="|σ| = 0.20 (C/m²)")

ylims!(ax1, 0.0, 1.0)

axislegend(ax1, position=:lt, labelsize=20)

Label(fig[1,1,TopLeft()], "(a)", fontsize=35, font=:bold, padding=(20,0,15,0))

ax2 = Axis(fig[2,1], ylabel="η (%)", xticks=(x, materials), limits=(0.5,6.5,0.0,100.0), yticks=0:10:100, titlesize=30, xlabelsize=28, ylabelsize=28, xticklabelsize=25, yticklabelsize=25)

scatterlines!(ax2, x, Rᵢ[1,:]; color=:indianred, linestyle=:dash, linewidth=4, marker=:circle, markersize=20, strokecolor=:black, strokewidth=1.5, label="|σ| = 0.05 (C/m²)")
scatterlines!(ax2, x, Rᵢ[2,:]; color=:springgreen2, linestyle=:dash, linewidth=4, marker=:circle, markersize=20, strokecolor=:black, strokewidth=1.5, label="|σ| = 0.10 (C/m²)")
scatterlines!(ax2, x, Rᵢ[3,:]; color=:dodgerblue, linestyle=:dash, linewidth=4, marker=:circle, markersize=20, strokecolor=:black, strokewidth=1.5, label="|σ| = 0.20 (C/m²)")

ylims!(ax2, 50, 100)

Label(fig[2,1,TopLeft()], "(b)", fontsize=35, font=:bold, padding=(20,0,15,0))

display(fig)