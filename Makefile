SWEAVE = Rscript -e "Sweave('$<')"

Espe_rice_yield_improvement.pdf: output/breed_paper.Rnw output/breeding.bib
	cd output && Rscript -e "Sweave('breed_paper.Rnw')" && \
	pdflatex breed_paper.tex && \
	bibtex breed_paper && \
	pdflatex breed_paper.tex && \
	pdflatex breed_paper.tex && \
	cp breed_paper.pdf ../Espe_rice_yield_improvement.pdf

output/freq.pdf: output/freq.Rmd
	cd output && Rscript -e "knitr::knit('freq.Rmd')" && \
	pandoc freq.md -o freq.pdf

output/breed_paper.Rnw: output/h1_fit.Rda
	cd output && Rscript -e "Sweave('breed_paper.Rnw')"

output/summary.pdf: output/summary.tex
	cd output && pdflatex summary.tex

output/summary.tex: output/summary.Rnw data/all_vt_weather.Rda src/prep_model_data.R output/h1_fit.Rda
	cd output && R CMD Sweave summary.Rnw

output/h1_fit.Rda: src/h1_model.R data/model_data.rda 
	cd src && Rscript h1_model.R

data/model_data.rda: data/all_vt_weather.Rda src/prep_model_data.R src/yield_model.stan data/yrTbl.Rda src/munge_pre95.R
	cd src && Rscript prep_model_data.R

data/yrTbl.Rda: data/var_list.txt src/getYears.R
	cd src && Rscript getYears.R

output/summary2.pdf: output/summary2.Rmd
	cd output && Rscript -e "library(knitr); knit('summary2.Rmd')" && pandoc summary2.md -o summary2.pdf

clean:
	rm output/*.pdf
	rm output/graphics/*
	rm output *.aux *.blg *.bbl *.log *.aux
