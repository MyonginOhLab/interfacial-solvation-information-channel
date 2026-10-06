using XLSX, DataFrames
using CairoMakie

filename = joinpath(@__DIR__, "figure5.xlsx")

xlsx = XLSX.readxlsx(filename)
sheet_names = XLSX.sheetnames(xlsx)

titles = ["H₂O", "MeCN", "MeOH", "EtOH", "PrOH", "DMSO"]
letters = ["(a)", "(b)", "(c)", "(d)", "(e)", "(f)"]

ncols, nrows = 2, 3

fig = Figure(size=(800,1200))

for (i, sheet_name) in enumerate(sheet_names)
    df = DataFrame(XLSX.readtable(filename, sheet_name))

    N = df.N
    negpos005 = df.negpos005
    negpos010 = df.negpos010
    negpos020 = df.negpos020

    row = div(i-1, ncols) + 1
    col = mod(i-1, ncols) + 1

    ax = Axis(fig[row,col], xlabel="N", ylabel="Pₑ(N)", title=titles[i], xticks=0:10:100, yticks=0.0:0.1:0.5, titlesize=30, xlabelsize=28, ylabelsize=28, xticklabelsize=25, yticklabelsize=25)

    lines!(ax, N, negpos005, label="|σ| = 0.05 (C/m²)", linewidth=3,color=:indianred)
    lines!(ax, N, negpos010, label="|σ| = 0.10 (C/m²)", linewidth=3, color=:springgreen2)
    lines!(ax, N, negpos020, label="|σ| = 0.20 (C/m²)", linewidth=3, color=:dodgerblue)

    xlims!(ax, 0, 60)
    if i == 1
        ylims!(ax, -0.005, 0.5)
        axislegend(ax, position=:rt, labelsize=20)
    elseif i == 4 || i == 5
        ylims!(ax, -0.005, 0.3)
    else
        ylims!(ax, -0.005, 0.4)
    end

    Label(fig[row,col,TopLeft()], letters[i], fontsize=35, font=:bold, padding=(20,0,15,0))
end

display(fig)