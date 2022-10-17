.SECONDEXPANSION :

INPUT_DIR ?= ./pdfs
INTERMEDIATE_DIR ?= ./intermediate
OUTPUT_DIR ?= ./texts

.PHONY : all
all :
	$(MAKE) encoded_filenames
	$(MAKE) pages
	$(MAKE) text

# FILENAME.json for every FILENAME in the encoded_filenames directory
ALL_JSON = $(patsubst $(INTERMEDIATE_DIR)/encoded_filenames/%,$\
                  $(OUTPUT_DIR)/%.json,$\
                  $(wildcard $(INTERMEDIATE_DIR)/encoded_filenames/*))

.PHONY : text
text : $(ALL_JSON)

# for every page image file associated with a FILENAME create .txt
# targets, i.e.
# page_images/FILENAME/page-001.ppm => ocr_text/FILENAME/page-001.ppm.text
#
# there are two levels of substitution going on here, which is why
# we need to do this as function instead of just an implicit dependency
define ocr_text
$(patsubst $(INTERMEDIATE_DIR)/page_images/%,$\
      $(INTERMEDIATE_DIR)/ocr_text/%.txt,$\
      $(wildcard $(INTERMEDIATE_DIR)/page_images/$(1)/*))
endef

# And we then combine the text for every page image into a
# a json array.
$(OUTPUT_DIR)/%.json : $$(call ocr_text,%)
	mkdir -p $(dir $@)
	python scripts/combine_text.py $* $^ > $@

# Finally we ocr each page image
$(INTERMEDIATE_DIR)/ocr_text/%.txt: $(INTERMEDIATE_DIR)/optimized_images/%
	mkdir -p $(dir $@)
	tesseract -l eng --dpi 150 $< $(basename $@) txt

# This does a little image processing to make it easier to OCR
$(INTERMEDIATE_DIR)/optimized_images/% : $(INTERMEDIATE_DIR)/page_images/%
	mkdir -p $(dir $@)
	python scripts/ImageCorrection.py $< $@

# Once we have a convenient naming convention for the source pdfs, we
# need to convert all the pages of the pdf to images, in particular
# PPMs
page_images = $(addprefix $(INTERMEDIATE_DIR)/page_images/,$\
                          $(notdir $(wildcard $(INTERMEDIATE_DIR)/encoded_filenames/*)))

pages : $(page_images)

$(INTERMEDIATE_DIR)/page_images/% : $(INTERMEDIATE_DIR)/encoded_filenames/%
	mkdir -p $@
	touch $@
	- pdftoppm -r 150 $< $@/page


# Filenames come in a wonderful variety and some are a pain to work
# with within a Make and others won't play well with a Linux OS. So,
# as preliminary step, we will working with symbolic links to the real
# files where the names of the links are hashes of the original file
# name
.PHONY : encoded_filenames
encoded_filenames :
	mkdir -p $(INTERMEDIATE_DIR)/encoded_filenames
	ls $(INPUT_DIR)/* | python scripts/hash_and_link.py $(INTERMEDIATE_DIR)/encoded_filenames
