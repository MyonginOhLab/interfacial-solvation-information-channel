using CairoMakie

sigma = ["0.05", "0.10", "0.20"]

alpha_H₂O = [0.45153067, 0.358423917, 0.20634547]
beta_H₂O = [0.366579785, 0.287163971, 0.171536783]
one_minus_alpha_H₂O = 1 .- alpha_H₂O
one_minus_beta_H₂O  = 1 .- beta_H₂O

alpha_MeCN = [0.384695174, 0.228226853, 0.147135436]
beta_MeCN = [0.258965476, 0.164679885, 0.11676878]
one_minus_alpha_MeCN = 1 .- alpha_MeCN
one_minus_beta_MeCN  = 1 .- beta_MeCN

alpha_MeOH = [0.32926459, 0.161760495, 0.033706881]
beta_MeOH = [0.292699337, 0.167082706, 0.06393575]
one_minus_alpha_MeOH = 1 .- alpha_MeOH
one_minus_beta_MeOH  = 1 .- beta_MeOH

alpha_EtOH = [0.238982641, 0.101527423, 0.036801787]
beta_EtOH = [0.263643144, 0.139878727, 0.050624094]
one_minus_alpha_EtOH = 1 .- alpha_EtOH
one_minus_beta_EtOH  = 1 .- beta_EtOH

alpha_PrOH = [0.242787722, 0.07928403, 0.038987089]
beta_PrOH = [0.223476965, 0.132445177, 0.029847815]
one_minus_alpha_PrOH = 1 .- alpha_PrOH
one_minus_beta_PrOH  = 1 .- beta_PrOH

alpha_DMSO = [0.315601008, 0.125881149, 0.0032149]
beta_DMSO = [0.330922521, 0.196445707, 0.047336512]
one_minus_alpha_DMSO = 1 .- alpha_DMSO
one_minus_beta_DMSO  = 1 .- beta_DMSO

x = 1:length(sigma)

x_alpha = x .- 0.18
x_beta  = x .+ 0.18

fig = Figure(size=(700,1300))

ax1 = Axis(fig[1,1], title="H₂O", xlabel="|σ| (C/m²)", xticks=(x,string.(sigma)), yticks=0:0.25:1, limits=(0.5,3.5,0,1), titlesize=30, xlabelsize=28, ylabelsize=28, xticklabelsize=25, yticklabelsize=25)

barplot!(ax1, x_alpha, alpha_H₂O, width=0.35, color=:firebrick1, strokecolor=:black, strokewidth=3)
barplot!(ax1, x_alpha, one_minus_alpha_H₂O, offset=alpha_H₂O, width=0.35, color=:firebrick4, strokecolor=:black, strokewidth=3)
barplot!(ax1, x_beta, beta_H₂O, width=0.35, color=:springgreen1, strokecolor=:black, strokewidth=3)
barplot!(ax1, x_beta, one_minus_beta_H₂O, offset=beta_H₂O, width=0.35, color=:springgreen4, strokecolor=:black, strokewidth=3)

Label(fig[1,1,TopLeft()], "(a)", fontsize=35, font=:bold, padding=(20,0,15,0))

ax2 = Axis(fig[1,2], title="MeCN", xlabel="|σ| (C/m²)", xticks=(x,string.(sigma)), yticks=0:0.25:1, limits=(0.5,3.5,0,1), titlesize=30, xlabelsize=28, ylabelsize=28, xticklabelsize=25, yticklabelsize=25)

barplot!(ax2, x_alpha, alpha_MeCN, width=0.35, color=:firebrick1, strokecolor=:black, strokewidth=3)
barplot!(ax2, x_alpha, one_minus_alpha_MeCN, offset=alpha_MeCN, width=0.35, color=:firebrick4, strokecolor=:black, strokewidth=3)
barplot!(ax2, x_beta, beta_MeCN, width=0.35, color=:springgreen1, strokecolor=:black, strokewidth=3)
barplot!(ax2, x_beta, one_minus_beta_MeCN, offset=beta_MeCN, width=0.35, color=:springgreen4, strokecolor=:black, strokewidth=3)

Label(fig[1,2,TopLeft()], "(b)", fontsize=35, font=:bold, padding=(20,0,15,0))

ax3 = Axis(fig[2,1], title="MeOH", xlabel="|σ| (C/m²)", xticks=(x,string.(sigma)), yticks=0:0.25:1, limits=(0.5,3.5,0,1), titlesize=30, xlabelsize=28, ylabelsize=28, xticklabelsize=25, yticklabelsize=25)

barplot!(ax3, x_alpha, alpha_MeOH, width=0.35, color=:firebrick1, strokecolor=:black, strokewidth=3)
barplot!(ax3, x_alpha, one_minus_alpha_MeOH, offset=alpha_MeOH, width=0.35, color=:firebrick4, strokecolor=:black, strokewidth=3)
barplot!(ax3, x_beta, beta_MeOH, width=0.35, color=:springgreen1, strokecolor=:black, strokewidth=3)
barplot!(ax3, x_beta, one_minus_beta_MeOH, offset=beta_MeOH, width=0.35, color=:springgreen4, strokecolor=:black, strokewidth=3)

Label(fig[2,1,TopLeft()], "(c)", fontsize=35, font=:bold, padding=(20,0,15,0))

ax4 = Axis(fig[2,2], title="EtOH", xlabel="|σ| (C/m²)", xticks=(x,string.(sigma)), yticks=0:0.25:1, limits=(0.5,3.5,0,1), titlesize=30, xlabelsize=28, ylabelsize=28, xticklabelsize=25, yticklabelsize=25)

barplot!(ax4, x_alpha, alpha_EtOH, width=0.35, color=:firebrick1, strokecolor=:black, strokewidth=3)
barplot!(ax4, x_alpha, one_minus_alpha_EtOH, offset=alpha_EtOH, width=0.35, color=:firebrick4, strokecolor=:black, strokewidth=3)
barplot!(ax4, x_beta, beta_EtOH, width=0.35, color=:springgreen1, strokecolor=:black, strokewidth=3)
barplot!(ax4, x_beta, one_minus_beta_EtOH, offset=beta_EtOH, width=0.35, color=:springgreen4, strokecolor=:black, strokewidth=3)

Label(fig[2,2,TopLeft()], "(d)", fontsize=35, font=:bold, padding=(20,0,15,0))

ax5 = Axis(fig[3,1], title="PrOH", xlabel="|σ| (C/m²)", xticks=(x,string.(sigma)), yticks=0:0.25:1, limits=(0.5,3.5,0,1), titlesize=30, xlabelsize=28, ylabelsize=28, xticklabelsize=25, yticklabelsize=25)

barplot!(ax5, x_alpha, alpha_PrOH, width=0.35, color=:firebrick1, strokecolor=:black, strokewidth=3)
barplot!(ax5, x_alpha, one_minus_alpha_PrOH, offset=alpha_PrOH, width=0.35, color=:firebrick4, strokecolor=:black, strokewidth=3)
barplot!(ax5, x_beta, beta_PrOH, width=0.35, color=:springgreen1, strokecolor=:black, strokewidth=3)
barplot!(ax5, x_beta, one_minus_beta_PrOH, offset=beta_PrOH, width=0.35, color=:springgreen4, strokecolor=:black, strokewidth=3)

Label(fig[3,1,TopLeft()], "(e)", fontsize=35, font=:bold, padding=(20,0,15,0))

ax6 = Axis(fig[3,2], title="DMSO", xlabel="|σ| (C/m²)", xticks=(x,string.(sigma)), yticks=0:0.25:1, limits=(0.5,3.5,0,1), titlesize=30, xlabelsize=28, ylabelsize=28, xticklabelsize=25, yticklabelsize=25)

barplot!(ax6, x_alpha, alpha_DMSO, width=0.35, color=:firebrick1, strokecolor=:black, strokewidth=3, label=L"\hat{\alpha}")
barplot!(ax6, x_alpha, one_minus_alpha_DMSO, offset=alpha_DMSO, width=0.35, color=:firebrick4, strokecolor=:black, strokewidth=3, label=L"1 \minus \hat{\alpha}")
barplot!(ax6, x_beta, beta_DMSO, width=0.35, color=:springgreen1, strokecolor=:black, strokewidth=3, label=L"\hat{\beta}")
barplot!(ax6, x_beta, one_minus_beta_DMSO, offset=beta_DMSO, width=0.35, color=:springgreen4, strokecolor=:black, strokewidth=3, label=L"1 \minus \hat{\beta}")

Label(fig[3,2,TopLeft()], "(f)", fontsize=35, font=:bold, padding=(20,0,15,0))

Legend(fig[4,2], ax6, labelsize=25, spacing=10, orientation=:horizontal)

display(fig)