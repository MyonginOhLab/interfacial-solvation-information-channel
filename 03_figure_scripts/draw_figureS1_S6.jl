using CSV, DataFrames
using CairoMakie

base_dir = joinpath(@__DIR__, "number_density_profiles")

folder_names = ["neg005", "neg010", "neg020", "pos005", "pos010", "pos020"]
csv_names = ["analysis_number_density_water.csv", "analysis_number_density_mecn.csv", "analysis_number_density_meoh.csv", "analysis_number_density_etoh.csv", "analysis_number_density_proh.csv", "analysis_number_density_dmso.csv"]

titles = ["H₂O", "MeCN", "MeOH", "EtOH", "PrOH", "DMSO"]
letters = ["(a)", "(b)", "(c)", "(d)", "(e)", "(f)"]

for (index, folder_name) in enumerate(folder_names)
    fig_num = index + 5
    folder_path = joinpath(base_dir, folder_name)

    ncols, nrows = 2, 3

    fig = Figure(size=(1000,1200))

    for i in 1:6
        csv_path = joinpath(folder_path, csv_names[i])

        df = CSV.read(csv_path, DataFrame)

        z = df[!, "z(A)"]
        rho = df[!, "rho(nm^-3)"]

        row = div(i-1,ncols) + 1
        col = mod(i-1,ncols) + 1

        ax = Axis(fig[row,col], xlabel="z (Å)", ylabel="ρ (nm⁻³)", title=titles[i], titlesize=30, xlabelsize=28, ylabelsize=28, xticklabelsize=25, yticklabelsize=25)

        if folder_name == "neg005" || folder_name == "pos005"
            lines!(ax, z, rho, linewidth=4, color=:indianred)
        elseif folder_name == "neg010" || folder_name == "pos010"
            lines!(ax, z, rho, linewidth=4, color=:springgreen2)
        else
            lines!(ax, z, rho, linewidth=4, color=:dodgerblue)
        end

        xlims!(ax, 0, 20)
        if i == 1
            ax.yticks=0:50:150
            ylims!(ax, -0.5, 150)
        elseif i == 2
            ax.yticks=0:20:80
            ylims!(ax, -0.5, 80)
        elseif i == 3 || i == 4 || i == 5
            ax.yticks=0:25:100
            ylims!(ax, -0.5, 100)
        else
            ax.yticks=0:20:60
            ylims!(ax, -0.5, 60)
        end

        Label(fig[row,col,TopLeft()], letters[i], fontsize=35, font=:bold, padding=(20,0,15,0))
    end

    display(fig)
end