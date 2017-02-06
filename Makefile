output/summary.tex: output/summary.Rnw data/all_vt_weather.Rda src/prep_model_data.R output/h1_fit.Rda
	cd output && R CMD Sweave summary.Rnw

output/summary.pdf: output/summary.tex
	cd output && pdflatex summary.tex

output/h1_fit.Rda: src/h1_model.R data/all_vt_weather.Rda src/prep_model_data.R
	cd src && Rscript h1_model.R

clean:
	rm output/*.pdf
