use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Tk::PlotDataset',
    AUTHOR              => 'I.T. Dev Ltd. <Contact via website - http://www.itdev.co.uk>',
    VERSION_FROM        => 'lib/Tk/PlotDataset.pm',
    ABSTRACT_FROM       => 'lib/Tk/PlotDataset.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'      => 0,
        'Tk::Canvas'      => 0,
        'Tk::DialogBox'   => 0,
        'Tk::BrowseEntry' => 0,
        'Tk::Balloon'     => 0
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Tk-PlotDataset-*' },
);
