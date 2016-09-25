# contrib/pg_stats/Makefile

EXTENSION = pg_stats
DATA = pg_stats--1.0.sql
PGFILEDESC = "pg_stats - customized statistics views"

ifdef USE_PGXS
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
else
subdir = contrib/pg_stats
top_builddir = ../..
include $(top_builddir)/src/Makefile.global
include $(top_srcdir)/contrib/contrib-global.mk
endif
