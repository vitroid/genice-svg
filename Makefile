.DELETE_ON_ERROR:
GENICE=genice2
BASE=genice2_svg
PACKAGE=genice2-svg
INKSCAPE=/Applications/Inkscape.app/Contents/MacOS/inkscape

all: README.md

pep8:
		autopep8 -r -a -a -i genice2_svg/

test: iceT2.svg.test CS2.svg iceR.svg CS2.png 4R.png
iceT2.svg: $(BASE)/formats/svg.py Makefile
	( cd $(BASE) && $(GENICE) iceT2 -f svg[shadow] ) > $@
CS2.svg: $(BASE)/formats/svg.py Makefile
	( cd $(BASE) && $(GENICE) CS2 -f svg[rotate=Y15,X5:polygon] ) > $@
iceR.svg: $(BASE)/formats/svg.py Makefile
	( cd $(BASE) && $(GENICE) iceR -f svg[rotate=X-35,Y45:shadow] ) > $@
CS2.png: $(BASE)/formats/png.py Makefile
	( cd $(BASE) && $(GENICE) CS2 -f png[rotate=Y15,X5:shadow] ) > $@
4R.png: $(BASE)/formats/png.py Makefile
	( cd $(BASE) && $(GENICE) 4R -f png[shadow:rotate=X2,Y88] ) > 4R.png
%.test:
	make $*
	diff $* ref/$*
%.svg.png: %.svg
	$(INKSCAPE) -z $< -d 150 -b white -o $@

%: temp_% replacer.py $(wildcard $(BASE)/lattices/*.py) $(wildcard $(BASE)/*.py)
	pip install genice2_dev svgwrite
	python replacer.py < $< > $@





test-deploy: build
	twine upload -r pypitest dist/*
test-install:
	pip install pillow
	pip install --index-url https://test.pypi.org/simple/ $(PACKAGE)



install:
	python ./setup.py install
uninstall:
	-pip uninstall -y $(PACKAGE)
build: README.md $(wildcard $(BASE)/lattices/*.py) $(wildcard $(BASE)/*.py)
	python ./setup.py sdist bdist_wheel


deploy: build
	twine upload dist/*
check:
	./setup.py check
clean:
	-rm $(ALL) *~ */*~ *svg CS2.png
	-rm -rf build dist *.egg-info
	-find . -name __pycache__ | xargs rm -rf
