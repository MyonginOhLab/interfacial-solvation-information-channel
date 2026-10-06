using XLSX, DataFrames
using CairoMakie

filename = joinpath(@__DIR__, "figure2.xlsx")

xlsx = XLSX.readxlsx(filename)
sheet_names = XLSX.sheetnames(xlsx)

titles = ["H₂O", "MeCN", "MeOH", "EtOH", "PrOH", "DMSO"]
letters = ["(a)", "(b)", "(c)", "(d)", "(e)", "(f)"]

ncols, nrows = 2, 3

fig = Figure(size=(900,1300))

for (i, sheet_name) in enumerate(sheet_names)
    df = DataFrame(XLSX.readtable(filename, sheet_name))

    cosTheta = df.cosTheta
    neg010 = df.neg010
    pos010 = df.pos010

    row = div(i-1, ncols) + 1
    col = mod(i-1, ncols) + 1

    ax = Axis(fig[row,col], xlabel="𝚯", ylabel="P(𝚯|S)", title=titles[i], xticks=-1.0:0.5:1.0, yticks=0.0:0.02:0.1, titlesize=30, xlabelsize=28, ylabelsize=28, xticklabelsize=25, yticklabelsize=25)

    lines!(ax, cosTheta, pos010, label="S=+", linewidth=3, color=:seagreen3)
    lines!(ax, cosTheta, neg010, label="S=−", linewidth=3, color=:tomato3)

    xlims!(ax, -1, 1)
    ylims!(ax, 0, 0.1)

    if i == 1
        axislegend(ax, position=:rt, labelsize=25)
    end
    Label(fig[row,col,TopLeft()], letters[i], fontsize=35, font=:bold, padding=(20,0,15,0))
end

display(fig)