#!perl -T

use Test::More;
eval "use Test::Pod::Coverage 1.04";
plan skip_all => "Test::Pod::Coverage 1.04 required for testing POD coverage" if $@;

all_pod_coverage_ok( { also_private => [qr/ClassInit|Populate|resize|rescale/,
                                        qr/callRedrawCallback|zoom|zoomInOut/,
                                        qr/createPlotAxis|titles|createTextV/,
                                        qr/legends|countY1|dataSetsMinMax/,
                                        qr/scalePlot|drawAxis|logTicks|drawDatasets/,
                                        qr/drawOneDataset|centerTextV|centerText/,
                                        qr/drawOneDatasetB|countInPoints|clipPlot/,
                                        qr/clipLineOutOut|clipLineInOut|toWorldPoints/,
                                        qr/toCanvasPixels|arraysToCanvasPixels/,
                                        qr/ds2PlotPixels|niceRange|logRange/] } );
