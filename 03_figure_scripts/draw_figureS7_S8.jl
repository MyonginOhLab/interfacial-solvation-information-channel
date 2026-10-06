using XLSX, DataFrames
using CairoMakie

filenames = ["summary_orientation_water.xlsx", "summary_orientation_mecn.xlsx", "summary_orientation_meoh.xlsx", "summary_orientation_etoh.xlsx", "summary_orientation_proh.xlsx", "summary_orientation_dmso.xlsx"]

titles = ["H₂O", "MeCN", "MeOH", "EtOH", "PrOH", "DMSO"]
letters = ["(a)", "(b)", "(c)", "(d)", "(e)", "(f)", "(g)", "(h)"]

ncols, nrows = 2, 3

fig = Figure(size=(900,1300))

for i in 1:6
    filename = joinpath(@__DIR__, filenames[i])

    sheet_name = "ori_dist_bac_err_mut"

    df = DataFrame(XLSX.readtable(filename, sheet_name))

    cosTheta = df.cosTheta
    neg020 = df.neg020
    pos020 = df.pos020
 
    row = div(i-1,ncols) + 1
    col = mod(i-1,ncols) + 1

    ax = Axis(fig[row,col], xlabel="𝚯", ylabel="P(𝚯|S)", title=titles[i], xticks=-1.0:0.5:1.0, yticks=0.0:0.03:0.15, titlesize=30, xlabelsize=28, ylabelsize=28, xticklabelsize=25, yticklabelsize=25)

    lines!(ax, cosTheta, pos020, label="S=+", linewidth=3, color=:seagreen3)
    lines!(ax, cosTheta, neg020, label="S=−", linewidth=3, color=:tomato3)

    xlims!(ax, -1, 1)
    ylims!(ax, 0, 0.15)
    
    if i == 1
        axislegend(ax, position=:rt, labelsize=25)
    end

    Label(fig[row,col,TopLeft()], letters[i], fontsize=35, font=:bold, padding=(20, 0, 15, 0))
end

display(fig)