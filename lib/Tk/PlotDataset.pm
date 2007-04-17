#!/usr/local/bin/perl -w

=head1 NAME

PlotDataset - An extended version of the canvas widget for plotting 2D line
              graphs. Plots have a legend and zooming capabilities.

=head1 SYNOPSIS

 use Tk;
 use Tk::PlotDataset;
 use Tk::LineGraphDataset;

 my $mainWindow = MainWindow -> new;

 my @data1 = (0..25);
 my $dataset1 = LineGraphDataset -> new
                                    (
                                      -name => 'Data Set One',
                                      -yData => \@data1,
                                      -yAxis => 'Y',
                                      -color => 'purple'
                                    );

 my @data2x = (0..25);
 my @data2y = ();
 foreach my $xValue (@data2x)
 {
   push (@data2y, $xValue ** 2);
 }
 my $dataset2 = LineGraphDataset -> new
                                    (
                                      -name => 'Data Set Two',
                                      -xData => \@data2x,
                                      -yData => \@data2y,
                                      -yAxis => 'Y1',
                                      -color => 'blue'
                                    );

 my $graph = $mainWindow -> PlotDataset
                            (
                              -width => 500,
                              -height => 500,
                              -background => 'snow'
                            ) -> pack(-fill => 'both', -expand => 1);

 $graph -> addDatasets($dataset1, $dataset2);

 $graph -> plot();

 MainLoop;

=head1 DESCRIPTION

PlotDataset is a quick and easy way to build an interactive plot widget into a
Perl application. The module is written entirely in Perl/Tk.

The widget is an extension of the Canvas widget that will plot LineGraphDataset
objects as lines onto a 2D graph. The axes can be automaically scaled or set by
the code. The axes can have linear or logrithmic scales and there is also an 
option of an additional y-axis (Y1).

=head2 Behaviour

When the cursor is on a plotted line, the line turns red to help identify that
line in the plot. Likewise when the cursor is over a Dataset name in the legend
the corresponding dataset line plot will turn red. Holding the cursor over a
point on the graph will display the point's coordinates in a help balloon.
Individual points are not shown when there are more than 20 points in the plot.

The left button (button-1) is used to zoom a graph. Move the cursor to one of
the corners of the box into which you want the graph to zoom. Hold down the
left button and move to the opposite corner. Release the left button and the
graph will zoom into the box. To undo one level of zoom click the left button
without moving the mouse.

=head2 Options

In addition to the Canvas options, the following option/value pairs are
supported. All of these options can be set in the new() function when the
PlotDataset object is created or by using the configure method:

=over 4

=item B<-colors>

An array of colours to use for the display of the data sets. If there are more
data sets than colours in the array then the colours will cycle. These colours
will be overwritten if the LineGraphDataset object already has a colour 
assigned to it.

=item B<-borders>

An array of four numbers which are the border sizes in pixels of the plot in
the canvas. The order is North (top), East (right), South (bottom) and West
(right).

=item B<-scale>

A nine element array of the minimum, maximum and step values of scales on each
of the three axes - x, y, and y1. The order of the nine values is xMin, xMax,
xStep, yMin, yMax, yStep, y1Min, y1Max and y1Step. The default values for all
the axis are 0 to 100 with a step size of 10.

=item B<-plottitle>

A two element array. The first element is the plot title, the second element is
the vertical offset of the title below the top edge of the window. The title is
centered in the x direction.

=item B<-xlabel>

The text label for the X-axis. The text is centered on the X-axis.

=item B<-ylabel>

The text label for the Y-axis. The text is centered on the Y-axis.

=item B<-y1label>

The text label for the Y1-axis, which is the optional axis to the right of the
plot. The text is centered on the Y1-axis.

=item B<-xType>

The scale type of the X-axis. Can be linear or log. The default type is
linear.

=item B<-yType>

The scale type of the Y-axis. Can be linear or log. The default type is
linear.

=item B<-y1Type>

The scale type of the y1 axis. Can be linear or log. The default type is
linear.

=item B<-fonts>

A four element array with the font names for the various labels in the plot.
The first element is the font of the numbers at the axis ticks, the second is
the font for the axis labels (all of them), the third is the plot title font
and fourth is the font for the legend.

 $graph -> configure(-fonts => 
                     [
                       'Times 8 bold', 
                       'Courier 8 italic', 
                       'Arial 12 bold', 
                       'Arial 10'
                     ]);

The format for each font string is; the name of the font, followed by its size
and then whether it should be in bold, italic or underlined.

=item B<-autoScaleX>

When set to "On" the X-axis will be scaled to the values to be plotted. Default
is "On". "Off" is the other possible value.

=item B<-autoScaleY>

When set to "On" the Y-axis will be scaled to the values to be plotted. Default
is "On". "Off" is the other possible value.

=item B<-autoScaleY1>

When set to "On" the Y1-axis will be scaled to the values to be plotted.
Default is "On". "Off" is the other possible value.

=item B<-logMin>

Applies to all logrithmic axes. A replacement value for zero or negative values
that cannot be plotted on a logarithmic axis.

=item B<-redraw>

A subroutine that is called when the graph is redrawn. It can be used to redraw
widgets, such as buttons, that have been added to the graph's canvas. Without
the subroutine anything on the graph would be overwritten.

 $graph -> configure
           (
             -redraw => sub
             {
               my $button = $graph -> Button(-text => 'Button');
               $graph -> createWindow
               (
                 $graph -> cget(-width) - 8, $graph -> cget(-height) - 8,
                 -anchor => 'se', -height => 18, -width => 100,
                 -window => $button
               );
             }
           );

=back

=head1 METHODS

=over 4

=item B<addDatasets($dataset1, $dataset2, etc...)>

Adds one or more dataset objects to the plot. Call the plot() method afterwards
to see the newly added datasets.

=item B<clearDatasets()>

Removes all the datasets from the plot. Call the plot() method afterwards to
clear the graph.

=item B<plot()>

Updates the graph to include changes to the graph's configuration or datasets.

Note: Changes to the graph's configuration or datasets will also be applied 
when the graph is rescaled when zooming in or out.

=back

=head1 HISTORY

This Tk widget is based on the Tk::LineGraph module by Tom Clifford. Due to
trouble with overriding methods that call methods using SUPER:: LineGraph could
not be used as a base class.

The main difference between this module and the original is that the graph is
created as a widget and not in a separate window. It therefore does not have
the drop down menus used to configure the graph in the original.

Other additions/alterations are:

=over 4

=item Z<>

- Used Tk::Balloon to add coordinate pop-ups to data points.

- Running the cursor over a line name in the legend will highlight the curve on
the graph.

- Added a clearDatasets method for removing all datasets from a plot.

- Added support for a -noLine boolean attribute of datasets.

- Added support for a -noLegend option for datasets, allowing them to be
excluded from the legend.

- Added -redraw option to allow a callback to be added to draw additional items
onto the canvas when it is redrawn.

- Option for a logarithmic scale on the x-axis (previously this was only
available on the y-axis).

- Removed all bindings for buttons 2 and 3.

=back

A number of bugs in the original code have also been found and fixed:

=over 4

=item Z<>

- Plots could be dragged using button 3 - this is not useful.

- If less than ten colours were provided, then the colour usage failed to
cycle and caused an error.

- If the user zooms beyond a range of approximately 1e-15, then it hangs.

- Scale values of 0 were frequently displayed as very small numbers
(approximately 1e-17).

- Small grey boxes were sometimes left behind when zooming out.

- In places, -tags was passed a string instead of an array reference,
which caused problems especially in the legends method.

- Corrected an issue with the positioning of the Y1 axis label.

- Corrected a divide by zero error occurring when a vertical data line
passes through a zoomed plot.

=back

=head1 BUGS

Currently there are no known bugs, but there are a couple of the limitations to
the module:

=over 4

=item Z<>

- If no data on the graph is plotted on the y-axis, i.e. the y1-axis is used
instead, then it is not possible to zoom the graph.

- In the case where the number of points in the x and y axes are different the
points with missing values are not plotted.

- Currently, if zero or negative numbers are plotted on a logarithmic scale
their values are set to the value of -logMin. This can produce strange looking
graphs when using mixed type axes. A future improvement would be to provide an
option to omit non-valid points from the graph.

=back

=head1 COPYRIGHT

Copyright 2007 I.T. Dev Ltd.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

Any code from the original Tk::LineGraph module is the copyright of Tom
Clifford.

=head1 AUTHOR

Andy Culmer and Tim Culmer. Contact via website - http://www.itdev.co.uk

Original code for the Tk::LineGraph module by Tom Clifford.

=head1 SEE ALSO

Tk::LineGraph Tk::LineGraphDataset

=head1 KEYWORDS

Plot 2D Axis

=cut

# Internal Revision History
#
# Filename : PlotDataset.pm
# Authors  : ac - Andy Culmer, I.T. Dev Limited
#            tc - Tim Culmer, I.T. Dev Limited
#
# Version 1 by ac on 19/12/2006
# Initial Version, modified from Tk::LineGraph.
#
# Version 2 by ac on 05/01/2007
# Changed the resize behaviour to allow the graph to be used with other widgets
# in the same window. This makes this widget more consistent with other Tk
# widgets.
#
# Version 3 by ac on 10/01/2007
# Added clearDatasets method to remove all datasets from a plot.
# Added support for a -noLine option for datasets, allowing them to be plotted
# points only.
# Added support for a noLegend option for datasets, allowing them to be excluded
# from the legend.
#
# Version 4 by ac on 23/01/2007
# Added -redraw option to allow a callback to be added to draw additional items
# onto the canvas when it is redrawn. Also corrected an issue with the
# positioning of the Y1 axis label.
#
# Version 5 by ac on 06/03/2007
# Corrected a divide by zero error occurring when a vertical data line passes
# through a zoomed plot.
#
# Version 6 by tc on 04/04/2007
# Prepared the module for submitting to CPAN.
#  * Removed unused code.
#  * Renamed the variables that use the reserved $a and $b variable names.
#  * Attempted to make the original TK::LineGraph source code conform to the
#    I.T. Dev coding standard.
#  * Added an option for a logarithmic scale on the x-axis.
#  * Added to original POD documentation.

package Tk::PlotDataset;

$VERSION = '1.00';

use POSIX;
use Carp;
use Tk::widgets qw/Canvas/;
use base qw/Tk::Derived Tk::Canvas/;
require Tk::DialogBox;
require Tk::BrowseEntry;
use Tk::Balloon;
use strict;
use warnings;

Construct Tk::Widget 'PlotDataset';

sub ClassInit
{
  my($class, $mw ) = @_;
  $class->SUPER::ClassInit($mw);
}

# Class data to track mega-item items. Not used as yet.
my $id = 0;
my %ids = ();

sub Populate
{
  my($self, $args) = @_;
  $self->SUPER::Populate($args);

  my @def_colors = qw/ gray SlateBlue1 blue1 DodgerBlue4  DeepSkyBlue2  SeaGreen3 green4 khaki4 gold3 gold1 firebrick1 brown4 magenta1 purple1 HotPink1 chocolate1 black/;
  $self->ConfigSpecs
  (
    -colors       => ['PASSIVE', 'colors',        'Colors',     \@def_colors],
    -border       => ['PASSIVE', 'border',        'Border',     [25,50,100,50] ],
    -scale        => ['PASSIVE', 'scale',         'Scale',      [0,100, 10, 0, 100, 10, 0, 100, 10] ],
    -zoom         => ['PASSIVE', 'zoom',          'Zoom',       [0, 0, 0, 0, 0] ],
    -plotTitle    => ['PASSIVE', 'plottitle',     'PlotTitle',  ['Default Plot Title',7 ] ],
    -xlabel       => ['PASSIVE', 'xlabel',        'Xlabel',     'X Axis Default Label'],
    -ylabel       => ['PASSIVE', 'ylabel',        'Ylabel',     'Y Axis Default Label'],
    -y1label      => ['PASSIVE', 'Y1label',       'Y1label',    'Y1 Axis Default Label'],
    -xTickLabel   => ['PASSIVE', 'xticklabel',    'Xticklabel',     undef],
    -yTickLabel   => ['PASSIVE', 'yticklabel',    'Yticklabel',     undef],
    -y1TickLabel  => ['PASSIVE', 'y1ticklabel',   'Y1ticklabel',    undef],
    -xType        => ['PASSIVE', 'xtype',         'Xtype',       'linear'],  # could be log
    -yType        => ['PASSIVE', 'ytype',         'Ytype',       'linear'],  # could be log
    -y1Type       => ['PASSIVE', 'y1type',        'Y1type',      'linear'],  # could be log
    -fonts        => ['PASSIVE', 'fonts',         'Fonts',       ['Arial 8','Arial 8','Arial 10 bold','Arial 10'] ],
    -autoScaleY   => ['PASSIVE', 'autoscaley',    'AutoScaleY',      'On'],
    -autoScaleX   => ['PASSIVE', 'autoscalex',    'AutoScaleX',      'On'],
    -autoScaleY1  => ['PASSIVE', 'autoscaley1',   'AutoScaleY1',     'On'],
    -logMin       => ['PASSIVE', 'logMin',        'LogMin',         0.001],
    -redraw       => ['PASSIVE', 'redraw',        'Redraw',         undef]
  );

  #helvetica Bookman Schumacher
  # The four fonts are axis ticks[0], axis lables[1], plot title[2], and legend[3]
  $self->{-logCheck} = 0; # false, don't need to check on range of log data
  # OK, setup the dataSets list
  $self->{-datasets}  = []; # empty array, will be added to
  $self->{-zoomStack} = []; # empty array which will get the zoom stack
  #Some bindings here
  # use button 1 for zoom
  $self->Tk::bind("<Button-1>" ,        [\&zoom, 0]);
  $self->Tk::bind("<ButtonRelease-1>" , [\&zoom, 1]);
  $self->Tk::bind("<B1-Motion>" ,       [\&zoom, 2]);

  # Add ballon help for the data points...
  my $parent = $self->parent; # ANDY
  $self->{Balloon} = $parent->Balloon();
  $self->{BalloonPoints} = {};
  $self->{Balloon}->attach($self, -balloonposition => 'mouse', -msg => $self->{BalloonPoints});

  $self->Tk::bind('<Configure>' => [\&resize] ); # Must use Tk:: here to avoid calling the canvas::bind method

} # end Populate

sub resize  # called when the window changes size (configured)
{
  use strict;
  my $self = shift;   # This is the canvas (Plot)

  my $w = $self->width;     # Get the current size
  my $h = $self->height;

  # now change the canvas area
  # but first look to see if it is already that size, then nothing to do
  my $ch = $self->cget('-height');
  my $cw = $self->cget('-width');
  # print "resize mw size is ($h,$w)  current canvas size is ($ch,$cw)\n";
  if((abs($ch-$h) > 10 ) or (abs($cw-$w) > 10 ) ) {
    $self->configure('-height'=> $h);
    $self->configure('-width'=> $w);
    # print "resize change the canvas size.\n";
    $self->rescale();
  }
  return;
}

sub rescale  # all, active, not
{
  # rescale the plot and redraw. Scale to  all or just active as per argument
  use strict;
  my($self, $how, %args)  = @_;
  $self->delete('all');  # empty the canvas, erase
  $self->scalePlot($how) unless(!defined($how) or $how eq "not");  # Get max and min for scalling
  $self->drawAxis();     # both x and y for now
  $self->titles();
  $self->drawDatasets(%args);
  $self->legends(%args);
  $self->callRedrawCallback;
}

sub callRedrawCallback
{
  my $self = shift;
  if(my $callback = $self->cget(-redraw))
  {
    $callback = [$callback] if(ref($callback) eq 'CODE');
    die "You must pass a list reference when using -redraw.\n" unless ref($callback) eq 'ARRAY';
    my($sub, @args) = @$callback;
    die "The array passed with the -redraw option must have a code reference as it's first element.\n" unless ref($sub) eq 'CODE';
    &$sub($self, @args);
  }
}

sub zoom
{
  # start to do the zoom
  use strict;
  my $self = shift;
  my $which = shift;
  my $z;
  # print "zoom which is <$which> self <$self> \n"if($which == 1  or $which == 3);
  if($which == 0)  # button 1 down
  {
    my $e = $self->XEvent;
    $z = $self->cget('-zoom');
    $z->[0] = $e->x; $z->[1] = $e->y;
    $self->configure('-zoom' => $z);
  }
  elsif($which == 1)  # button 1 release, that is do zoom
  {
    my $e = $self->XEvent;
    $z = $self->cget('-zoom');
    $z->[2] = $e->x; $z->[3] = $e->y;
    $self->configure('-zoom' => $z);
    # OK, we can now do the zoom
    # print "zoom $z->[0],$z->[1] $z->[2],$z->[3] \n";

    # If the box is small we undo one level of zoom
    if((abs($z->[0]-$z->[2]) < 3) and (abs($z->[1]-$z->[3]) < 3))
    {
      # try to undo one level of zoom
      if(@{$self->{'-zoomStack'}} == 0)  # no zooms to undo
      {
        $z = $self->cget('-zoom');
        $self->delete($z->[4])if($z->[4] != 0);
        return;
      }

      my $s = pop(@{$self->{'-zoomStack'}});
      # print "zoom off stack $s->[3], $s->[4] \n";
      $self->configure(-scale=>$s);
      if($self->cget('-xType') eq 'log')
      {
        my ($aa,$bb) = (10**$s->[0],10**$s->[1]);
        # print "zoom a $aa b $bb \n";
        my ($xMinP, $xMaxP, $xIntervals, $tickLabels) = $self->logRange($aa,$bb);
        # print "zoom $tickLabels \n";
        $self->configure(-xTickLabel=> $tickLabels);
      }
      if($self->cget('-yType') eq 'log')
      {
        my ($aa,$bb) = (10**$s->[3],10**$s->[4]);
        # print "zoom a $aa b $bb \n";
        my ($yMinP, $yMaxP, $yIntervals, $tickLabels) = $self->logRange($aa,$bb);
        # print "zoom $tickLabels \n";
        $self->configure(-yTickLabel=> $tickLabels);
      }
      if($self->cget('-y1Type') eq 'log')
      {
        my ($aa,$bb) = (10**$s->[6],10**$s->[7]);
        # print "zoom for y1 log  $aa b $bb \n";
        my ($yMinP, $yMaxP, $yIntervals, $tickLabels) = $self->logRange($aa,$bb);
        # print "zoom y1 $tickLabels \n";
        $self->configure(-y1tickLabel=> $tickLabels);
      }
    }
    else  # box not small, time to zoom
    {
      my ($x1W,$y1W,$y11W) = $self->toWorldPoints($z->[0],$z->[1]);
      my ($x2W,$y2W,$y12W) = $self->toWorldPoints($z->[2],$z->[3]);
      my $z; #holdem
      if($x1W  > $x2W)  { $z = $x1W;  $x1W =  $x2W;  $x2W  = $z; }
      if($y1W  > $y2W)  { $z = $y1W;  $y1W =  $y2W;  $y2W  = $z; }
      if($y11W > $y12W) { $z = $y11W; $y11W = $y12W; $y12W = $z; }

      # We've had trouble with extreme zooms, so trap that here...
      if(($x2W  - $x1W  < 1e-12) || ($y2W  - $y1W  < 1e-12) || ($y12W - $y11W < 1e-12))
      {
        $z = $self->cget('-zoom');
        $self->delete($z->[4])if($z->[4] != 0);
        return;
      }

      # push the old scale values on the zoom stack
      push(@{$self->{'-zoomStack'}}, $self->cget(-scale));
      # now rescale
      # print "zoom Rescale ($y1W, $y2W)  ($x1W, $x2W)  \n";
      my ($yMinP, $yMaxP, $yIntervals)    = niceRange($y1W, $y2W);
      my ($y1MinP, $y1MaxP, $y1Intervals) = niceRange($y11W, $y12W);
      my ($xMinP, $xMaxP, $xIntervals)    = niceRange($x1W, $x2W);
      my ($xTickLabels,$yTickLabels,$y1TickLabels);
      ($xMinP, $xMaxP, $xIntervals, $xTickLabels) = $self->logRange ($x1W, $x2W)if($self->cget('-xType') eq 'log');
      ($yMinP, $yMaxP, $yIntervals, $yTickLabels) = $self->logRange ($y1W, $y2W)if($self->cget('-yType') eq 'log');
      ($y1MinP, $y1MaxP, $y1Intervals, $y1TickLabels) = $self->logRange ($y11W, $y12W)if($self->cget('-y1Type') eq 'log');
      # print "zoom   ($xMinP, $xMaxP, $xIntervals)  xTickLabels <$xTickLabels> \n";
      $self->configure(-xTickLabel=> $xTickLabels);
      $self->configure(-yTickLabel=> $yTickLabels);
      # print "($xMinP, $xMaxP,$xIntervals), ($yMinP, $yMaxP, $yIntervals),  ($y1MinP, $y1MaxP, $y1Intervals)\n";
      $self->configure(-scale=>[$xMinP, $xMaxP, $xIntervals,$yMinP, $yMaxP, $yIntervals, $y1MinP, $y1MaxP, $y1Intervals]);
    }

    $self->delete('all');
    # draw again
    $self->drawAxis();     # both x and y for now
    $self->titles();
    $self->drawDatasets();
    $self->legends();
    $self->callRedrawCallback;

  }
  elsif($which == 2)  # motion, draw box
  {
    my $e = $self->XEvent;
    $z = $self->cget('-zoom');
    $self->delete($z->[4])if($z->[4] != 0);
    $z->[4] = $self->createRectangle($z->[0],$z->[1],$e->x,$e->y,'-outline'=>'gray');
    $self->configure('-zoom' => $z);
  }
}

sub zoomInOut  # arg is which 1 is zoom out 2 is zoom in
{
  # zoom out by two in both x and y.
  use strict;
  my $self = shift;
  my $which = shift;
  my $div = ($which == 1) ? 1 :4 ;
  my $i = ($which == 1) ? 2 :0.5 ;
  my $s =  $self->cget(-scale);
  # just change the scale and redraw.
  my ($delta, $mid);
  $delta = ($s->[1] - $s->[0]) / $div;
  $mid = ($s->[1] + $s->[0]) / 2;
  $s->[0] = $mid - $delta; #new min
  $s->[1] = $mid + $delta; #new max
  $s->[2] = $s->[2] * $i;
  $delta = ($s->[4] - $s->[3]) / $div;
  $mid = ($s->[4] + $s->[3]) / 2;
  $s->[3] = $mid - $delta; #new min
  $s->[4] = $mid + $delta; #new max
  $s->[5] = $s->[5] * $i;
  $delta = ($s->[7] - $s->[6]) / $div;
  $mid = ($s->[7] + $s->[6]) / 2;
  $s->[6] = $mid - $delta; #new min
  $s->[7] = $mid + $delta; #new max
  $s->[8] = $s->[8] * $i;

  $self->delete('all');
  # draw again
  $self->drawAxis();     # both x and y for now
  $self->titles();
  $self->drawDatasets();
  $self->legends();
  $self->callRedrawCallback;
}

sub createPlotAxis  # start and end point of the axis, other args a=>b
{
  # Optional args  -tick
  # Optional args  -label
  # end points are in Canvas pixels
  use strict;
  my($self, $x1, $y1, $x2, $y2, %args) = @_;
  my $y_axis = 0;
  if ($x1 == $x2)
  {
    $y_axis = 1;
  }
  elsif ($y1 != $y2)
  {
    die "Cannot determine if X or Y axis desired."
  }

  my $tick = delete $args{-tick};
  my $label = delete $args{-label};
  my($do_tick, $do_label) = map {ref $_ eq 'ARRAY'} ($tick, $label);

  $self->createLine($x1, $y1, $x2, $y2, %args);

  if ($do_tick)
  {
    my($tcolor, $tfont, $side, $start, $stop, $incr, $delta, $type) = @$tick;
    # start, stop are in the world system
    # $incr is space between ticks in world coordinates   $delta is the number of pixels between ticks
    # If type is log then a log axis maybe not
    my($lcolor, $lfont, @labels) = @$label if $do_label;
    # print "t font <$tfont> l font <$lfont> \n";
    my $l;
    my $z = 0;  # will get $delta added to it, not x direction!
    my $tl;
    my $an;
    if ($y_axis)
    {
      $tl = $side eq 'w' ? 5 : -6; # tick length
      $an = $side eq 'w' ? 'e' : 'w' if $y_axis;  #anchor
    }
    else
    {
      $tl = $side eq 's' ? 5 : -6; # tick length
      $an = $side eq 's' ? 'n' : 's' if not $y_axis;
    }
    # do the ticks
    $incr = 1 if(($stop - $start) < 1e-15); # AC: Rounding errors can cause an infinite loop when range is zero!
    # This line above fixes this by detecting this case and fixing the increment to 1. (Of course, range should not be zero anyway!)
    #   print "ticks for loop $l = $start; $l <= $stop; $l += $incr\n"; # DEBUG
    for(my $l = $start; $l <= $stop; $l += $incr)
    {
      if ($y_axis)
      {
        $self->createLine
               (
                 $x1-$tl,  $y2-$z, $x1, $y2-$z,
                 %args, -fill => $tcolor,
               );
      }
      else
      {
        $self->createLine
               (
                 $z+$x1,  $y1+$tl, $z+$x1, $y2,
                 %args, -fill => $tcolor,
               );
      }
      if ($do_label)
      {
        my $lbl = shift(@labels);
        if ($y_axis)
        {
          $self->createText
                 (
                   $x1-$tl, $y2-$z, -text => $lbl,
                   %args, -fill => $lcolor,
                   -font => $lfont, -anchor => $an,
                 ) if $lbl;
        }
        else
        {
          $self->createText
                 (
                   $z+$x1, $y1+$tl, -text => $lbl,
                   %args, -fill => $lcolor,
                   -font => $lfont, -anchor => $an,
                 ) if $lbl;
        }
      }
      else  # default label uses tfont
      {
        $l = 0 if(($l < 1e-15) && ($l > -1e-15)); # Fix rounding errors at zero.
        if ($y_axis)
        {
          $self->createText
                 (
                   $x1-$tl, $y2-$z, -text => sprintf('%.3g', $l),
                   %args, -fill => $tcolor,
                   -font => $tfont, -anchor => $an,
                 );
        }
        else
        {
          $self->createText
                 (
                   $z+$x1, $y1+$tl, -text => sprintf('%.3g', $l),
                   %args, -fill => $tcolor,
                   -font => $tfont, -anchor => $an,
                 );
        }
      }
      $z += $delta;  # only use of delta
    }
  } # ifend label this axis

} # end createPlotAxis

sub titles
{
  # put axis titles and plot title on the plot
  # x, y, y1, plot all at once for now
  use strict;
  my $self = shift;
  my $borders = $self->cget(-border);
  my $fonts = $self->cget('-fonts');
  my $w = $self->cget('-width');
  my $h = $self->cget('-height');
  my $yp = $borders->[2]*0.6;
  # y axis
  my $yStart = $self->centerTextV($borders->[0], $h - $borders->[2], $fonts->[1], $self->cget('-ylabel'));
  $self->createTextV
         (
           $self->toCanvasPixels('canvas', 10, $h - $yStart),
           -text => $self->cget('-ylabel'), -anchor => 's', -font => $fonts->[1], -tag => "aaaaa",
         );

  # Is y1 axis used for active datasets?

  # y1 axis
  my $y1Start = $self->centerTextV($borders->[0], $h - $borders->[2], $fonts->[1], $self->cget('-y1label'));
  $self->createTextV
         (
           $self->toCanvasPixels('canvas', $w - 5, $h - $y1Start),
           -text => $self->cget('-y1label'), -anchor => 'sw', -font => $fonts->[1], -tag => "y1y1y1y1",
         ) if($self->countY1());

  #   x axis
  my $xStart = $self->centerText($borders->[3], $w - $borders->[2], $fonts->[1], $self->cget('-xlabel'));
  $self->createText
         (
           $self->toCanvasPixels('canvas', $xStart, $yp),
           -text => $self->cget('-xlabel'), -anchor => 'sw', -font => $fonts->[1],
         );

  # add a plot title
  my $p = $self->cget('-plotTitle');
  $xStart = $self->centerText($borders->[3],$w-$borders->[1], $fonts->[1],$p->[0]);
  $self->createText
         (
           $self->toCanvasPixels('canvas',$xStart, $h - $p->[1]),
           text => $p->[0], -anchor => 'nw', -font => $fonts->[2], -tags => ['title']
         );
}

sub createTextV  # canvas widget, x,y, then all the text arguments plus -scale=>number
{
  # Writes text from top to bottom.
  # For now argument -anchor is removed
  # scale is set to 0.75.  It the fraction of the previous letter's height that the
  # current letter is lowered.
  #
  use strict;
  my $self = shift;
  my ($x, $y) = (shift,shift);
  my %args = @_;
  my $text = delete($args{-text});
  my $anchor = delete($args{-anchor});
  my $scale = delete($args{-scale});
  my $tag = delete($args{-tag});
  my @letters = split(//,$text);
  # print "args",  %args, "\n";;
  # OK we know that we have some short and some long letters
  # a,c,e,g,m,m,o,p,r,s,t,u,v,w,x,y,z are all short.  They could be moved up a tad
  # also g,j,q, and y hang down, the next letter has to be lower
  my $th = 0;
  my $lc = 0;

  my($fontWidth) = $self->fontMeasure($args{-font}, 'M'); # Measure a wide character to determine the x offset
  $x -= $fontWidth if $anchor =~ /w/; # AC: Implement missing functionality!

  # sorry to say, the height of all the letters as returned by bbox is the same for a given font.
  # same is true for the text widget.  Nov 2005!
  my $letter = shift(@letters);
  $self->createText($x, $y+$th, -text => $letter, -tags => [$tag], %args, -anchor => 'c');  # first letter
  my ($minX, $minY, $maxX, $maxY) = $self->bbox($tag);
  my $h = $maxY - $minY;
  my $w = $maxX - $minX;
  my $step = 0.80;
  $th = $step*$h + $th;
  foreach my $letter (@letters)
  {
    # print "createTestV letter <$letter>\n";
    # If the letter is short, move it up a bit.
    $th = $th - 0.10*$h if($letter =~ /[acegmnoprstuvwxyz.;,:]/);  # move up a little
    $th = $th - 0.40*$h if($letter =~ /[ ]/);                    # move up a lot
    # now write the letter
    $self->createText($x, $y+$th, -text => $letter, -tags => [$tag], %args, -anchor => 'c');
    # space for the next letter
    $th = $step*$h + $th;
    $th = $th + 0.10*$h if($letter =~ /[gjpqy.]/);  # move down a bit if the letter hangs down
    $lc++;
  }
}

sub legends
{
  # For all the (active) plots, put a legend
  my ($self, %args) = @_;
  my $count = 0;
  # count the (active) data sets
  foreach my $ds (@{$self->{-datasets}})
  {
    unless($ds->get(-noLegend))
    {
      $count++ if($ds->get('-active') == 1);
    }
  }
  # print "legends have $count legends to do\n";
  my $fonts = $self->cget('-fonts');
  my $xs = 20;
  foreach my $ds (@{$self->{-datasets}})
  {
    unless($ds->get(-noLegend))
    {
      if($ds->get('-active') != 99)  # do them all, not just active
      {
        my($x,$y) = $self->toCanvasPixels('canvas',$xs, 5);
        my $lineTag = $ds->get('-name');
        my $tag = $lineTag.'legend';
        my $fill = $ds->get('-color');
        my $t = $ds->get('-name');
        $t = ($ds->get('-yAxis') eq "Y1") ? $t."(Y1) " : $t." ";
        $self->createText($x,$y, -text=>$t, -anchor => 'sw', -fill => $ds->get('-color'), -font=>$fonts->[3],-tags=>[$tag]);
        # If multiple curves, turn the line and the plot name red when we enter it with the cursor in the legend
        if(scalar(@{$self->{-datasets}}) > 1)
        {
          $self->bind
          (
            $tag, "<Enter>"=> sub
            {
              # print "Highlighting <$lineTag> and <$tag>.\n";
              $self->itemconfigure($lineTag, -fill=>'red');
              $self->itemconfigure($tag,     -fill=>'red');
            }
          );
          $self->bind
          (
            $tag, "<Leave>"=> sub
            {
              $self->itemconfigure($lineTag, -fill=>$fill);
              $self->itemconfigure($tag,     -fill=>$fill);
            }
          );
        }
        my($x1,$y1,$x2,$y2) = $self->bbox($tag);
        if($x2)
        {
          $xs = $x2;
        }
        else
        {
          $xs += 100;
        }
        #     print "legend location of last character p1($x1,$y1), p2($x2,$y2)\n";
      }
    }
  }
}

sub addDatasets
{
  # add data sets to the plot object
  my($self, @datasets) = @_;
  foreach my $dataset (@datasets)
  {
    push @{$self->{-datasets}}, $dataset;
  }
}

sub clearDatasets
{
  # removes all data sets from the plot object
  my($self) = @_;
  @{$self->{-datasets}} = ();
  return(1);
}

sub countY1
{
  # count how many datasets are using y1
  use strict;
  my $self = shift;
  my $count = 0;
  foreach my $ds (@{$self->{-datasets}}) {
    $count++ if($ds->get('-yAxis') eq "Y1");
  }
  # print "countY1 <$count>\n";
  return($count);
}

sub dataSetsMinMax  # one argument, all or active
{
  # Get the min and max of the datasets
  # could be done for all datasets or just the active datasets
  # return xmin,xmax, ymin, ymax, y1min, y1max
  use strict;
  my $self = shift;
  my $all;
  if (defined($_[0]))
  {
    $all = (shift eq 'all') ? 1 : 0;  # $all true if doing for all datasets
  }
  my ($first, $first1) = (0, 0);
  my $e; # element
  my ($yMax, $yMin, $xMax, $xMin, $yMax1, $yMin1) = (0, 0, 0, 0, 0, 0);
  my ($xData, $yData);
  # Do x then y and y1
  foreach my $ds (@{$self->{-datasets}})
  {
    if(($all) or ($ds->get('-active') == 1))
    {
      $yData = $ds->get('-yData');
      $xData = $ds->get('-xData');
      $xData = [0..scalar(@$yData)]  unless(defined($xData));
      if($first == 0)
      {
        $xMax = $xMin = $xData->[0];
        $first = 1;
      }
      foreach $e (@{$xData})
      {
        $xMax = $e if($e > $xMax );
        $xMin = $e if($e < $xMin );
      }
    }
  }
  $first = $first1 = 0;
  foreach my $ds (@{$self->{-datasets}})
  {
    if(($all) or ($ds->get('-active') == 1) )
    {
      $yData = $ds->get('-yData');
      if($ds->get('-yAxis') eq "Y1")
      {
        if($first1 == 0)
        {
          $yMax1 = $yMin1 = $yData->[0];
          $first1 = 1;
        }
        foreach $e (@{$yData})
        {
          $yMax1 = $e if($e > $yMax1);
          $yMin1 = $e if($e < $yMin1);
        }
      }
      else
      {  # for y axis
        if($first == 0)
        {
          $yMax = $yMin = $yData->[0];
          $first = 1;
        }
        foreach $e (@{$yData})
        {
          $yMax = $e if($e > $yMax);
          $yMin = $e if($e < $yMin);
        }
      }
    }
  }
  # print "datasetMinMax X($xMin,$xMax), Y($yMin, $yMax), Y1($yMin1, $yMax1)\n";
  return($xMin, $xMax, $yMin, $yMax, $yMin1, $yMax1);
}

sub scalePlot  # 'all'  or 'active'
{
  # scale either all the data sets or just the active ones
  use strict;
  my $self = shift;
  my $how = shift;
  my($xMin, $xMax, $yMin, $yMax, $y1Min, $y1Max) = $self->dataSetsMinMax($how);
  # print "scalePlot  min and max  ($xMin, $xMax), ($yMin, $yMax),  ($y1Min, $y1Max)\n";
  my($xtickLabels, $ytickLabels, $y1tickLabels);
  my($yMinP,  $yMaxP,  $yIntervals);
  my $scale = $self->cget(-scale);
  if($self->cget(-autoScaleY) eq 'On')
  {
    ($yMinP, $yMaxP, $yIntervals) = niceRange($yMin, $yMax);
    ($yMinP, $yMaxP, $yIntervals, $ytickLabels) = $self->logRange($yMin, $yMax) if($self->cget('-yType') eq 'log');
  }
  else
  {
    ($yMinP, $yMaxP, $yIntervals) = ($scale->[3], $scale->[4], $scale->[5]);
  }
  my($y1MinP, $y1MaxP, $y1Intervals);
  if($self->cget(-autoScaleY1) eq 'On')
  {
    ($y1MinP, $y1MaxP, $y1Intervals) = niceRange($y1Min, $y1Max);
    ($y1MinP, $y1MaxP, $y1Intervals, $y1tickLabels) = $self->logRange ($y1Min, $y1Max) if($self->cget('-y1Type') eq 'log');
  }
  else
  {
    ($y1MinP, $y1MaxP, $y1Intervals) = ($scale->[6], $scale->[7],$scale->[8]);
  }
  my($xMinP,  $xMaxP,  $xIntervals);
  if($self->cget(-autoScaleX) eq 'On')
  {
    ($xMinP, $xMaxP, $xIntervals) = niceRange($xMin, $xMax);
    ($xMinP, $xMaxP, $xIntervals, $xtickLabels) = $self->logRange ($xMin, $xMax) if($self->cget('-xType') eq 'log');
  }
  else
  {
    ($xMinP, $xMaxP, $xIntervals) = ($scale->[0], $scale->[1],$scale->[2]);
  }
  # print "scalePlot $yMinP,  $yMaxP,  $yIntervals, @$ytickLabels\n";
  # print "($xMinP, $xMaxP, $xIntervals)  tickLabels <$tickLabels> \n";
  $self->configure(-xTickLabel=>  $xtickLabels);
  $self->configure(-yTickLabel=>  $ytickLabels);
  $self->configure(-y1TickLabel=> $y1tickLabels);
  # print "scale Y $yMinP, $yMaxP, $yIntervals  X  $xMinP, $xMaxP, $xIntervals \n";
  # put these scale values into the plot widget
  $self->configure(-scale=>[$xMinP, $xMaxP, $xIntervals,  $yMinP, $yMaxP, $yIntervals,  $y1MinP, $y1MaxP, $y1Intervals]);
  # print "in scale  $yMinP, $yMaxP, $yIntervals \n";
  # reset the zoom stack!
  $self->{-zoomStack} = [];
}

sub plot
{
  # plot all the active data sets
  # no arguments
  use strict;
  my($self) = @_;

  $self->rescale('all');
}

sub drawAxis
{
  # do both of the axis
  my $self = shift;
  my $s = $self->cget(-scale);  # get the scale factors
  my ($nb, $eb, $sb, $wb) = @{$self->cget(-border)};
  # for now, figure this will fit
  my $h = $self->cget('-height');
  my $w = $self->cget('-width');
  my $xTickLabel = $self->cget('-xTickLabel');
  my $fonts = $self->cget('-fonts');
  # print "drawAxis xTickLabel <$xTickLabel>\n";
  my $lab = [];
  if($xTickLabel)
  {
    # print "draw axis making tick labels\n";
    push @{$lab},'black', $fonts->[0] ;
    foreach my $tl (@{$xTickLabel})
    {
      push @{$lab}, $tl;
      # print "drawAxis @{$lab} \n";
    }
  }
  else
  {
    $lab = undef;
  }

  # xAxis first
  # tick stuff
  my ($tStart, $tStop, $interval) =  ($s->[0], $s->[1], $s->[2]);
  my $ticks = ($tStop-$tStart)/$interval;
  my $aLength = $w-$wb-$eb;
  my $d = $aLength/$ticks;
  my ($xStart, $ystart, $xEnd, $yEnd) = ($wb, $h-$sb, $w-$eb, $h-$sb);
  my $result = $self->createPlotAxis
                      (
                        $xStart, $ystart, $xEnd, $yEnd,
                        -fill => "black",
                        # $tcolor, $tfont,  $side, $start, $stop, $incr, $delta)
                        # incr step size - used in lable in PIXELS, delta is the PIXELS  between ticks
                        # have to start at the start of the "axis".  Not good!
                        -tick => ['black',$fonts->[0],'s',$tStart,$tStop,$interval,$d],
                        -label =>$lab,
                      );

  # box x axis
  ($xStart, $ystart, $xEnd, $yEnd) = ($wb, $nb, $w-$eb, $nb);
  $result = $self->createPlotAxis
                   (
                     $xStart, $ystart, $xEnd, $yEnd,
                     -fill => "black"
                   );

  # setup the tick labels if they have been set
  my $yTickLabel = $self->cget('-yTickLabel');
  if($yTickLabel)
  {
    # print "draw axis making tick labels for y\n";
    push @{$lab},'black', $fonts->[0] ;
    foreach my $tl (@{$yTickLabel})
    {
      push @{$lab}, $tl;
      # print "drawAxis @{$lab} \n";
    }
  }
  else
  {
    $lab = undef;
  }
  # print "y axis label <$lab> \n";
  #YAxis now
  ($xStart, $ystart, $xEnd, $yEnd) = ($wb, $nb, $wb, $h-$sb);
  ($tStart, $tStop, $interval) =  ($s->[3], $s->[4], $s->[5]);
  $interval = 10 if($interval <= 0);
  $ticks = ($tStop-$tStart)/$interval;
  $aLength = $h-$nb-$sb;
  $d = $aLength/$ticks;
  $result = $self->createPlotAxis
                   (
                     $xStart, $ystart, $xEnd, $yEnd,
                     -fill => "black",
                     # $tcolor, $tfont,  $side, $start, $stop, $incr, $delta)
                     # incr step size - used in lable in PIXELS, delta is the PIXELS  between ticks
                     # have to start at the start of the "axis".  Not good!
                     -tick => ['black', $fonts->[0], 'w', $tStart, $tStop, $interval, $d],
                     -label => $lab,
                   );

  #Y1Axis now if needed
  if($self->countY1())
  {
    # setup the tick labels if they have been set
    my $y1TickLabel  = $self->cget('-y1TickLabel');
    if($y1TickLabel)
    {
      # print "draw axis making tick labels for y\n";
      push @{$lab},'black', $fonts->[0] ;
      foreach my $tl (@{$y1TickLabel})
      {
        push @{$lab}, $tl;
        # print "drawAxis @{$lab} \n";
      }
    }
    else
    {
      $lab = undef;
    }
    ($xStart, $ystart, $xEnd, $yEnd) = ($w-$eb, $nb, $w-$eb, $h-$sb);
    ($tStart, $tStop, $interval) =  ($s->[6], $s->[7], $s->[8]);
    $interval = 10 if($interval <= 0);
    $ticks = ($tStop-$tStart)/$interval;
    $aLength = $h - $nb - $sb;
    $d = ($ticks != 0) ? $aLength/$ticks : 1;
    $result = $self->createPlotAxis
                     (
                       $xStart, $ystart, $xEnd, $yEnd,
                       -fill => "black",
                       # $tcolor, $tfont,  $side, $start, $stop, $incr, $delta)
                       # incr step size - used in lable in PIXELS, delta is the PIXELS  between ticks
                       # have to start at the start of the "axis".  Not good!
                       -tick => ['black', $fonts->[0], 'e', $tStart, $tStop, $interval, $d],
                       -label => $lab,
                     );
  }
  # box    y axis
  ($xStart, $ystart, $xEnd, $yEnd) = ($w-$eb, $nb, $w-$eb, $h-$sb);
  $result = $self->createPlotAxis
                   (
                     $xStart, $ystart, $xEnd, $yEnd,
                     -fill => "black",
                   );
  $self->logTicks();
}

sub logTicks
{
  # put the 2,3,4,...,9 ticks on a log axis
  use strict;
  my $self = shift;
  my $s = $self->cget('-scale');
  my ($h,$w) = ($self->cget('-height'),  $self->cget('-width'));
  my $borders = $self->cget('-border');
  # do x axis
  if($self->cget('-xType') eq 'log')
  {
    my ($minP, $maxP, $deltaP) = ($s->[0], $s->[1],$s->[2]);
    my $dec = ($maxP-$minP);
    unless($dec > 5)  # only if there are less than four decades
    {
      my $axisLength = $w - $borders->[1] - $borders->[3];
      my $dLength = $axisLength/($maxP-$minP);
      my $delta;
      my $y = $h - $borders->[2];
      foreach my $ii (1..$dec)
      {
        foreach my $i (2..9)
        {
          my $delta = (log10 $i) * $dLength;
          my $x = ($borders->[3]) + $delta + $dLength*($ii-1);
          # print "logTicks $ii $i delta $delta  y $y \n";
          $self->createLine($x, $y, $x, $y+6, -fill=>'black');
        }
      } # end each decade
    }
  }
  # do y axis
  if($self->cget('-yType') eq 'log')
  {
    my ($minP, $maxP, $deltaP) = ($s->[3], $s->[4],$s->[5]);
    my $dec = ($maxP-$minP);
    unless($dec > 5)  # only if there are less than four decades
    {
      my $axisLength = $h - $borders->[0] - $borders->[2];
      my $dLength = $axisLength/($maxP-$minP);
      my $delta;
      foreach my $ii (1..$dec)
      {
        foreach my $i (2..9)
        {
          my $delta = (log10 $i) * $dLength;
          my $y = $h - ($borders->[2]) - $delta - $dLength*($ii-1);;
          # print "logTicks $ii $i delta $delta  y $y \n";
          $self->createLine($borders->[3], $y, $borders->[3]+6, $y, -fill=>'black');
        }
      } # end each decade
    }
  }
}

sub drawDatasets
{
  # draw the line(s) for all active datasets
  use strict;
  my ($self, @args) = @_;
  %{$self->{BalloonPoints}} = (); # Clear the balloon help hash before drawing.
  foreach my $ds (@{$self->{-datasets}})
  {
    if($ds->get('-active') == 1)
    {
      $self->drawOneDataset($ds);
    }
  }
} # end plotDatasets

sub drawOneDataset  # index of the dataset to draw, widget args
{
  # draw even if not active ?
  my ($self, $ds, %args) = @_;
  # %args seems not to be used here.
  my ($nb, $eb, $sb, $wb) = @{$self->cget(-border)};
  my $fill;
  my $index  = $ds->get('-index');
  my $noLine = $ds->get('-noLine'); # AC - added option to plot points only
  if($ds->get('-color') eq "none")
  {
    my $colors = $self->cget(-colors);
    $fill = $self->cget('-colors')->[$index % @$colors];
    $ds->set('-color'=>$fill);
  }
  else
  {
    $fill = $ds->get('-color');
  }
  my $tag = $ds->get('-name');
  my $yax  = $ds->get('-yAxis');  # does this dataset use y or y1 axis
  # print "drawOneDataSet index <$index> color  <$fill> y axis <$yax>\n";
  my $yData = $ds->get('-yData');
  my $xData = $ds->get('-xData');
  $xData = [0..(scalar(@$yData)-1)]  unless(defined($xData));
  my $logMin = $self->cget(-logMin);
  my $x = [];
  # if x-axis uses a log scale convert x data
  if($self->cget('-xType') eq 'log')
  {
    foreach my $e (@{$xData})
    {
      $e = $logMin if($e <= 0);
      push @{$x}, log10($e);
    } # end foreach
  }
  else  # not log at all
  {
    $x = $xData;
  }
  my $y = [];
  # just maybe we have a log plot to do.  In that case must take the log of each point
  if((($yax eq "Y1") and ($self->cget('-y1Type') eq 'log')) or (($yax eq "Y") and ($self->cget('-yType') eq 'log')))
  {
    foreach my $e (@{$yData})
    {
      $e = $logMin if($e <= 0);
      push @{$y}, log10($e);
    } # end foreach
  }
  else  # not log at all
  {
    $y = $yData;
  }

  # need to make one array out of two
  my @xyPoints;
  # right here we need to go from data set coordinates to plot PIXEL coordinates

  my($xReady, $yReady) = $self->ds2PlotPixels($x, $y, $yax);
  @xyPoints =  $self->arraysToCanvasPixels('axis', $xReady, $yReady);
  # got to take care of the case where the data set is empty or just one point.
  return  if(@xyPoints == 0);
  if(@xyPoints == 2)
  {
    # print "one point, draw a dot!\n";
    my($xa,$ya) = ($xyPoints[0],$xyPoints[1]);
    $self->createOval($xa-6,$ya-6, $xa+6,$ya+6, -fill=>$fill, -tags=>[$tag]);
  }
  else
  {
    $self->drawOneDatasetB(-data => \@xyPoints, -fill=>$fill, -tags=>[$tag], -xData => $xData, -yData => $yData, -noLine => $noLine);
  }

  # If multiple curves, turn the plot name in the legend and the line red when we enter the line with the cursor
  if(scalar(@{$self->{-datasets}}) > 1)
  {
    $self->bind($tag,"<Enter>"=> sub
    {
      $self->itemconfigure($tag, -fill => 'red');
      $self->itemconfigure($tag . 'legend', -fill => 'red');
    } );
    $self->bind($tag,"<Leave>"=> sub
    {
      $self->itemconfigure($tag, -fill => $fill);
      $self->itemconfigure($tag . 'legend', -fill => $fill);
    } );
  }
} # end plotDatasets

sub centerTextV  # given y1,y2, a font and a string
{
  # return a y value for the start of the text
  # The system is in canvas, that is 0,0 is top right.
  # return -1 if the text will just not fit
  use strict;
  my $self = shift;
  my($y1, $y2, $f, $s) = @_;
  return(-1) if($y1 > $y2);
  my $g = "gowawyVVV";
  $self->createTextV
         (
           0, 10000,  -text=>$s, -anchor => 'sw',
           -font=>$f,-tag=>$g
         );
  my ($minX, $minY, $maxX, $maxY) = $self->bbox($g);
  # print "centerTextV ($minX,$minY,$maxX,$maxY)\n";
  $self->delete($g);
  my $space = $y2-$y1;
  my $strLen = $maxY - $minY;
  return(-1) if($strLen > $space);
  # print "centerTextV $y1,$y2, space $space, strLen $strLen\n";
  return( ($y1+$y2-$strLen)/2);
}

sub centerText  # x1,x2 a font and a string
{
  # return the x value fo where to start the text to center it
  # forget about leading and trailing blanks!!!!
  # Return -1 if the text will not fit
  use strict;
  my $self = shift;
  my($x1, $x2, $f, $s) = @_;
  return(-1) if($x1 > $x2);
  my $g = "gowawy";
  $self->createText
         (
           0, 10000,  -text=>$s, -anchor => 'sw',
           -font=>$f,-tags=>[$g]
         );
  my ($minX, $minY, $maxX, $maxY) = $self->bbox($g);
  $self->delete($g);
  my $space = $x2-$x1;
  my $strLen = $maxX - $minX;
  return(-1) if($strLen > $space);
  return(($x1+$x2 - $strLen)/2);
}

sub drawOneDatasetB  # takes same arguments as createLinePlot confused
{
  # do clipping if needed
  # do plot with dots if needed
  use strict;
  my ($self, %args) = @_;
  my $xyPoints = delete($args{'-data'});
  my $xData  = delete($args{'-xData'});  # Take the original data for use
  my $yData  = delete($args{'-yData'});  # in the balloon popups.
  my $noLine = delete($args{'-noLine'}); # Add a switch to allow points-only plots
  # $self->createLinePlot(-data => $xyPoints, %args);
  $self->clipPlot(-data => $xyPoints, %args) unless $noLine;
  my $h = $self->cget('-height');
  my $w = $self->cget('-width');
  my $borders = $self->cget(-border);
  # How many points are inside of the plot window.
  # mark the points if there are less that 20 points
  my $points = @{$xyPoints}/2;
  my $inPoints = $self->countInPoints($xyPoints);
  if($inPoints < 20)
  {
    my $tags = delete($args{'-tags'});
    for(my $i = 0; $i < $points; $i++)
    {
      my $pointTag = $$tags[0] . "($i)";
      # print "Point tag = $pointTag\n"; # DEBUG
      my @pointTags = (@$tags, $pointTag);
      my ($x,$y) = ($xyPoints->[$i*2], $xyPoints->[$i*2+1]);
      $self->{BalloonPoints}->{$pointTag} = sprintf("%.3g, %.3g", $$xData[$i], $$yData[$i]);
      $self->createOval($x-3, $y-3, $x+3, $y+3, %args, -tags => \@pointTags) if(($x >= $borders->[3])  and ($x <= ($w - $borders->[1]))  and ($y >= $borders->[0]) and ($y <= ($h - $borders->[2])) );
    }
  }
}

sub countInPoints  # array of x,y points
{
  # count the points inside the plot box.
  my ($self) = shift;
  my $xyPoints = shift;
  my $points = @{$xyPoints}/2;
  my $count = 0;
  my $h = $self->cget('-height');
  my $w = $self->cget('-width');
  my $borders = $self->cget(-border);

  for(my $i = 0; $i < $points; $i++)
  {
    my ($x, $y) = ($xyPoints->[$i*2], $xyPoints->[$i*2+1]);
    $count++ if(($x >= $borders->[3]) and ($x <= ($w - $borders->[1])) and ($y >= $borders->[0]) and ($y <= ($h - $borders->[2])) );
  }
  return($count);
}

sub clipPlot  # -data => array ref which contains x,y points in Canvas pixels
{
  # draw a multi point line but cliped at the borders
  my ($self, %args) = @_;
  my $xyPoints = delete($args{'-data'});
  my $pointCount = (@{$xyPoints})/2;
  my $h = $self->cget('-height');
  my $w = $self->cget('-width');
  my $lastPoint = 1; # last pointed plotted is flaged as being out of the plot box
  my $borders = $self->cget(-border);
  my @p;  # a new array with points for line segment to be plotted
  my ($x,$y);
  my ($xp,$yp) = ($xyPoints->[0], $xyPoints->[1]); # get the first point
  if(($xp >= $borders->[3]) and ($xp <= ($w - $borders->[1])) and ($yp >= $borders->[0]) and ($yp <= ($h - $borders->[2])))
  {
    # first point is in, put points in the new array
    push @p, ($xp,$yp);  # push the x,y pair
    $lastPoint = 0; # flag the last point as in
  }
  for(my $i=1; $i< $pointCount; $i++)
  {
    ($x,$y) = ($xyPoints->[$i*2], $xyPoints->[$i*2+1]);
    # print "clipPlot $i ($x $borders->[3]) and ($x $w $borders->[1]) ($y $borders->[0]) ($y ($h - $borders->[2])) lastPoint  $lastPoint\n";
    if(($x >= $borders->[3])  and ($x <= ($w - $borders->[1]))  and ($y >= $borders->[0]) and ($y <= ($h - $borders->[2])) )
    {
      # OK, this point is in, if the last one was out then we have work to do
      if( $lastPoint == 1)  #out
      {
        $lastPoint = 0;   # in
        my($xn,$yn) = $self->clipLineInOut($x, $y, $xp, $yp, $borders->[3], $borders->[0], $w - $borders->[1], $h - $borders->[2]);
        push (@p, ($xn,$yn));
        push (@p, ($x, $y));
        ($xp,$yp) = ($x, $y);
      }
      else  # last point was in, this  in  so we just add a point to the line and carry on
      {
        push (@p, ($x, $y));
        ($xp,$yp) =  ($x, $y);
      } # end else
    }
    else  # this point out
    {
      my @args = %args;
      if($lastPoint == 0)  # in
      {
        # this point is out, last one was in, need to draw a line
        my ($xEdge,$yEdge) = $self->clipLineInOut($xp, $yp, $x, $y, $borders->[3], $borders->[0], $w - $borders->[1], $h - $borders->[2]);
        push @p, $xEdge,$yEdge;
        $self->createLine(\@p,%args);
        splice(@p,0);  # empty the array?
        $lastPoint = 1;   # out
        ($xp,$yp) =  ($x, $y );
      }
      else  # two points in a row out but maybe the lies goes thru the active area
      {
        # print "clip two points in a row out of box.\n";
        my $p = $self->clipLineOutOut($xp, $yp, $x, $y, $borders->[3], $borders->[0], $w - $borders->[1], $h - $borders->[2]);
        $self->createLine($p,%args)if(@$p >= 4);
        $lastPoint = 1; # out!
        ($xp,$yp) = ($x, $y );
      } # end else
    }
  } # end loop
  # now when we get out of the loop if there are any points in the @p array, make a line
  $self->createLine(\@p,%args) if(@p >= 4);
}

sub clipLineOutOut  # x,y  ,  x,y  and x,y corners of the box
{
  # see if the line goes thru the box
  # If so, draw the line
  # else do nothing
  my ($self,$x1,$y1,$x2,$y2,$xb1,$yb1,$xb2,$yb2) = @_;  # wow!
  my (@p,$x,$y);
  # print "clipLine ($x1,$y1) , ($x2,$y2),($xb1,$yb1) ,($xb2,$yb2)\n";
  return(\@p)if( ($x1 < $xb1) and ($x2 < $xb1));  # line not in the box
  return(\@p)if( ($x1 > $xb2) and ($x2 > $xb2));
  return(\@p)if( ($y1 > $yb2) and ($y2 > $yb2));
  return(\@p)if( ($y1 < $yb1) and ($y2 < $yb1));
  # get here the line might pass thru the plot box
  # print "clipLineOutOut p1($x1,$y1), p2($x2,$y2), box1($xb1,$yb1), box2($xb2,$yb2)\n";
  if($x1 != $x2)
  {
    my $m = ($y1-$y2)/($x1-$x2);    # as in y = mx + c
    my $c = $y1 - $m*$x1;
    # print "clipLineOutOut line m $m c $c\n";
    $x = ($m != 0) ? ($yb1-$c)/$m : $x1 ; #   print "$x $yb1\n";
    push @p, ($x,$yb1) if( ($x >= $xb1) and ($x <= $xb2) );
    $x = ($m != 0) ? ($yb2-$c)/$m : $x1 ;
    push @p, ($x,$yb2) if( ($x >= $xb1) and ($x <= $xb2) );
    $y = $m*$xb1 + $c;
    push @p, ($xb1,$y) if( ($y >= $yb1) and ($y <= $yb2) );
    $y = $m*$xb2 + $c;
    push @p, ($xb2,$y) if( ($y >= $yb1) and ($y <= $yb2) );
  }
  else  # Handle vertical lines...
  {
    $x = $x1; # This is also $x2 of course!
    push @p, ($x,$yb1) if( ($x >= $xb1) and ($x <= $xb2) );
    $x = $x1 ;
    push @p, ($x,$yb2) if( ($x >= $xb1) and ($x <= $xb2) );
  }
  # print "clifLineOutOut @p", "\n";
  return(\@p)
}

sub clipLineInOut  # x,y (1 in), x,y (2 out)   and x,y corners of the box
{
  # We have two points, one in the box, one outside of the box
  # Find where the line between the two points intersects the edges of the box
  # returns that point
  # Notebook page 106
  my ($self,$x1,$y1,$x2,$y2,$xb1,$yb1,$xb2,$yb2) = @_;  # wow!
  # print "clipLine ($x1,$y1) , ($x2,$y2),($xb1,$yb1) ,($xb2,$yb2)\n";
  my ($xi,$yi);
  if($x1 == $x2)  # line par to y axis
  {
    # print "clipLine line parallel to y axis\n";
    $xi = $x1;
    $yi = ($y2 < $yb1) ? $yb1  : $yb2;
    return($xi,$yi);
  }
  if($y1 == $y2)  # line par to x axis
  {
    # print "clipLine line parallel to y axis\n";
    $yi = $y1;
    $xi = ($x2 < $xb1) ? $xb1 : $xb2;
    return($xi,$yi);
  }
  # y = mx + b;   m = dy/dx   b = y1 - m*x1  x = (y-b)/m
  if(($x1-$x2) != 0)
  {
    my $m = ($y1-$y2)/($x1-$x2);
    my $c = $y1 - $m*$x1;
    if($y2 <= $y1)  # north border
    {
      $xi = ($yb1-$c)/$m;
      return($xi,$yb1) if(($xi >= $xb1) and ($xi <= $xb2));
    }
    else  # south border
    {
      $xi = ($yb2-$c)/$m;
      return($xi,$yb2) if(($xi >= $xb1) and ($xi <= $xb2));
    }
    if($x2 <= $x1)  # west border
    {
      $yi = $m*$xb1 + $c;
      return($xb1,$yi) if(($yi >= $yb1) and ($yi <= $yb2));
    }
    # only one remaining is east border
    $yi = $m*$xb2 + $c;
    return($xb2,$yi) if(($yi >= $yb1) and ($yi <= $yb2));
  }
  else  # dx == 0, vertical line, north or south border
  {
    return($x1,$yb1)if($y2 <= $yb1);
    return($x1,$yb2)if($y2 >= $yb2);
  }
  warn "clip Line cannot get to here!";
  return(0,0);
}

# There are three coordinate systems in use.
# 1. World  - Units are the physical system being plotted. Amps, DJ Average, dollars, etc
# 2. Plot   - Units are pixels. The (0,0) point is the lower left corner of the canvas
# 3. Canvas - Units are pixels. The (0,0) point is the upper left corner of the canvas.

sub toWorldPoints  # x,y in the Canvas system
{
  # convert to World points
  # get points on canvas from system in pixels, need to change them into units in the plot
  my ($self,$xp,$yp)  = @_;
  my $borders = $self->cget(-border);   # north, east, south, west
  my $s = $self->cget(-scale);     # min X, max X, interval, min y, max y,
  my $h = $self->cget(-height);
  my $w = $self->cget(-width);
  my $x = ($xp - $borders->[3]) * ($s->[1] - $s->[0]) / ($w - $borders->[1] - $borders->[3]) + $s->[0];
  my $y = (($h-$yp) - $borders->[2]) * ($s->[4] - $s->[3]) / ($h - $borders->[0] - $borders->[2]) + $s->[3];
  # but if the axes are log some more work to do.
  my $y1 = (($h - $yp) - $borders->[2]) * ($s->[7] - $s->[6]) / ($h - $borders->[0] - $borders->[2]) + $s->[6];
  $x = 10**$x   if($self->cget('-xType')  eq 'log');
  $y = 10**$y   if($self->cget('-yType')  eq 'log');
  $y1 = 10**$y1 if($self->cget('-y1Type') eq 'log');
  # print "toWorldPoints ($xp,$yp) to ($x,$y,$y1\n";
  return($x,$y,$y1);
}

sub toCanvasPixels  # which, x,y
{
  # given an x,y value in axis or canvas system return x,y in Canvas pixels.
  # axis => x,y are pixels relative to where the border is
  # canvas => x,y are pixels in the canvas system.
  # more to follow ?
  my($self, $which, $x, $y) = @_;
  my ($xOut, $yOut);
  if($which eq 'axis')
  {
    my $borders = $self->cget(-border);
    return($x + $borders->[3], $self->cget('-height') - ($y + $borders->[2]));
  }
  if($which eq 'canvas')
  {
    return($x, $self->cget('-height')-$y);
  }
} # end to canvas pixels

sub arraysToCanvasPixels  # which, x array ref, y array ref
{
  # given x array ref and y aray ref generate the one array, xy in canvas pixels
  my($self, $which, $xa, $ya) = @_;
  my @xyOut;
  my $h = $self->cget('-height');
  my $borders = $self->cget(-border);
  if($which eq 'axis')
  {
    for (my $i=0;$i<@$ya; $i++)
    {
      $xyOut[$i*2]   = $xa->[$i] + $borders->[3];
      $xyOut[$i*2+1] = $h - ($ya->[$i] + $borders->[2]);
    }
    return (@xyOut);
  }
}

sub ds2PlotPixels  # ref to xArray and yArray with ds values, which y axis
{
  # ds is dataSet.  They are in world system
  # convert to Plot pixels, return ref to converted x array and y array
  my ($self, $xa, $ya, $yAxis) = @_;
  my $s = $self->cget(-scale);
  my ($xMin, $xMax, $yMin, $yMax);
  ($xMin, $xMax, $yMin, $yMax) = ($s->[0], $s->[1], $s->[3], $s->[4]);
  ($xMin, $xMax, $yMin, $yMax) = ($s->[0], $s->[1], $s->[6], $s->[7]) if($yAxis eq "Y1");
  # print "ds2PlotPixels X($xMin,$xMax),Y($yMin,$yMax)\n";
  my $borders = $self->cget(-border);
  my ($nb, $eb, $sb, $wb) = ($borders->[0], $borders->[1], $borders->[2], $borders->[3]);
  my $h = $self->cget('-height');
  my $w = $self->cget('-width');
  my (@xR, @yR);  # converted values to be returned
  my $sfX = ($w-$eb-$wb) / ($xMax-$xMin);
  my $sfY = ($h-$nb-$sb) / ($yMax-$yMin);
  my ($x, $y);
  for(my $i = 0; $i < @{$xa}; $i++)
  {
    push @xR, ($xa->[$i] - $xMin) * $sfX  if (defined($xa->[$i]));
    push @yR, ($ya->[$i] - $yMin) * $sfY  if (defined($ya->[$i]));
  }
  return(\@xR, \@yR);
}

sub niceRange  # input is min,max,
{
  # return is a new min, max and an interval for the tick marks
  # interval is not the number of intervals but the size of the interval
  # find a good min, max and interval for the axis
  # if min > max return min 0, max 100, interval of 10.
  use strict;
  my $min = shift;
  my $max = shift;
  my $delta = $max - $min;
  return(0, 100, 10) if($delta < 0);                                       # AC: Set standard scale for negative ranges
  return(int($min + 0.5) - 1, int($min + 0.5) + 1, 1) if($delta <= 1e-15); # AC: Set special scale for zero, or v. small ranges (v. small is usually caused by rounding errors!)
  my $r = ($max != 0) ? $delta/$max : $delta;
  $r = -$delta/$min if($max < 0);
  my $spaces = 10; # number
  # don't want a lot of ticks if the size of the space is very small compaired to values
  $spaces = 2 if($r < 1E-02);

  while(1 == 1)  # do this until a  return
  {
    # print "ratio <$r> \n";
    # $spaces = 2 if($r < 1E-08);
    my $interval = $delta / $spaces;
    my $power = floor(log10($delta));
    # print "min,max $min,$max  delta $delta  power $power interval $interval $spaces\n";
    # find a good interval for the ticks
    $interval = $interval * (10 ** -$power) * 10;
    # print "min,max $min,$max  delta $delta  power $power interval $interval\n";
    # now round this up the next whole number but not 3 or 6, 7 or 9.
    # leaves 1,2,4,5,8
    $interval = ceil($interval);
    $interval = 8  if(($interval == 7) or ($interval == 6));
    $interval = 10 if($interval == 9);
    $interval = 4  if($interval == 3);
    #print "min,max $min,$max  delta $delta  power $power interval $interval\n";
    $interval = $interval*(10**(+$power-1));
    #print "min,max $min,$max  delta $delta  power $power interval $interval\n";
    # find the new min
    my ($newMax, $newMin);
    my $newDelta = $interval * $spaces;
    if($newDelta == $delta)
    {
      $newMax = $max;
      $newMin = $min;
    }
    else
    {
      my $n = $min/$interval;
      my $nFloor = floor($n);
      # print "n $n floor of n is $nFloor \n";
      $newMin = $nFloor * $interval;
      $newMax = $newMin + $spaces * $interval;
    }
    # print "niceRange min,max $min,$max  delta $delta  power $power interval $interval newMin $newMin newMax $newMax \n";

    # now see how much of the space has been used.  If there is a lot empty, increase the number of spaces (tickes)
    return($newMin, $newMax, $interval) if($spaces <= 3);
    return($newMin, $newMax, $interval) if((($newDelta / $delta) < 1.4) and ($newMax >= $max));
    $spaces++;
  }
}

sub logRange  # min, max
{
  # for scaling a log axis
  #returns a max and min, intervals  and an array ref that contains labels for the ticks
  use strict;
  my $self = shift;
  my($min,$max) = (shift,shift);

  unless(defined($min) and defined($max))
  {
    $min = 0.1;
    $max = 1000;
  }

  if($min <= 0)
  {
    my $t = $self->cget(-logMin);
    # print "Can't log plot data that contains numbers less than or equal to zero.\n";
    # print "Data min is: <$min>.  Changed to $t\n";
    $min = $self->cget(-logMin);
    # set a flag to indicate the log data must be checked for min!
    $self->{-logCheck} = 1; # true
  }
  my $delta = $max-$min;
  my $first;
  my @tLabel;

  my $maxP =  ceil(log10($max));
  $maxP = $maxP+1 if($maxP>0);
  my $minP =  floor(log10($min));
  my $f;
  # print "logRange max $max,min $min,  $maxP,$minP)\n";
  foreach my $t ($minP..$maxP)
  {
    my $n = 10.0**$t;
    # print "logRange <$n> <$t>\n";
    $f = sprintf("1E%3.2d",$t)if($t<0);
    $f = sprintf("1E+%2.2d",$t)if($t>=0);
    # print "logRange $f \n";
    push @tLabel, $f;
  }
  return($minP,$maxP,1,\@tLabel);
  # look returning min Power and the max Power.  Note the power step is always 1 this might not be good
  # used  1E-10, 1E-11 and so on.  Looks good to me!
}

1;

