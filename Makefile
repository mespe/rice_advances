SWEAVE = Rscript -e "Sweave('$(notdir $<)')"

PDF_COMPILE = pdflatex $(notdir $<) && bibtex $(basename $(notdir $<)) && pdflatex $(notdir $<) && pdflatex $(notdir $<)


all_responses.pdf: output/review_responses.pdf output/diffs.pdf output/breed_paper_revised.pdf
	pdfunite $^ $@

output/review_responses.pdf: output/review_responses.tex output/response_letter.pdf
	cd output && pdflatex $(notdir $<)

response_letter.pdf: output/response_letter.tex
	cd output && pdflatex $(notdir $<)

Espe_rice_yield_improvement_revised.pdf: output/breed_paper_revised.tex output/breeding.bib
	cd output && \
	$(PDF_COMPILE) && \
	cp breed_paper_revised.pdf ../Espe_rice_yield_improvement_revised.pdf

output/breed_paper_revised.tex: output/breed_paper_revised.Rnw output/h1_fit_revised.Rda output/map.pdf
	cd output && \
	$(SWEAVE)

output/breed_paper.tex: output/breed_paper.Rnw output/h1_fit.Rda
	cd output && \
	$(SWEAVE)
output/map.pdf: src/maps.R
	cd src && Rscript maps.R

Espe_rice_yield_improvement.pdf: output/breed_paper.Rnw output/breeding.bib
	cd output && \
	$(PDF_COMPILE) && \
	cp breed_paper.pdf ../Espe_rice_yield_improvement.pdf

diffs.pdf: output/breed_paper.tex output/breed_paper_revised.tex
	cd output && \
	latexdiff breed_paper.tex breed_paper_revised.tex > diffs.tex && \
	pdflatex diffs.tex && bibtex diffs && pdflatex diffs.tex && pdflatex diffs.tex

output/supp_analysis.pdf: output/freq.Rmd
	cd output && Rscript -e "knitr::knit('freq.Rmd')" && \
	pandoc freq.md -o supp_analysis.pdf

output/summary.pdf: output/summary.tex
	cd output && pdflatex summary.tex

output/summary.tex: output/summary.Rnw data/all_vt_weather.Rda src/prep_model_data.R output/h1_fit.Rda
	cd output && R CMD Sweave summary.Rnw

h1_fit.Rda: src/h1_model.R data/model_data.rda 
	cd src && Rscript h1_model.R

h1_fit_revised.Rda: src/h1_model.R data/model_data.rda 
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
