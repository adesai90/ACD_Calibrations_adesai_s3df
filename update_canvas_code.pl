#!/usr/bin/env perl
use strict;
use warnings;

# File 1: AcdCalibUtil.cxx
my $file1 = $ARGV[0] || "/sdf/home/a/abhishek/ACD_calib/releases/GR-20-09-10/calibGenACD/src/AcdCalibUtil.cxx";

open(my $fh1, '<', $file1) or die "Cannot open $file1: $!";
my @lines1 = <$fh1>;
close($fh1);

open(my $out1, '>', $file1) or die "Cannot write to $file1: $!";
foreach my $line (@lines1) {
    print $out1 $line;
    # After Draw("colz"), add Update and ProcessEvents
    if ($line =~ /Draw\("colz"\);/) {
        print $out1 "    cnv.Update();              // added_AD\n";
        print $out1 "    gSystem->ProcessEvents();  // added_AD\n";
    }
}
close($out1);

print "Modified $file1\n";

# File 2: AcdPadMap.cxx
my $file2 = $ARGV[1] || "/sdf/home/a/abhishek/ACD_calib/releases/GR-20-09-10/calibGenACD/src/AcdPadMap.cxx";

open(my $fh2, '<', $file2) or die "Cannot open $file2: $!";
my @lines2 = <$fh2>;
close($fh2);

open(my $out2, '>', $file2) or die "Cannot write to $file2: $!";
for (my $i = 0; $i < @lines2; $i++) {
    print $out2 $lines2[$i];
    
    # After topB->Divide(5,5); add updates
    if ($lines2[$i] =~ /topB->Divide\(5,5\);/) {
        print $out2 "  topA->Update();              // added_AD\n";
        print $out2 "  gSystem->ProcessEvents();    // added_AD\n";
        print $out2 "  topB->Update();              // added_AD\n";
        print $out2 "  gSystem->ProcessEvents();    // added_AD\n";
    }
    
    # After cB->Divide(5,4); add updates
    if ($lines2[$i] =~ /cB->Divide\(5,4\);/) {
        print $out2 "    cA->Update();              // added_AD\n";
        print $out2 "    gSystem->ProcessEvents();  // added_AD\n";
        print $out2 "    cB->Update();              // added_AD\n";
        print $out2 "    gSystem->ProcessEvents();  // added_AD\n";
    }
    
    # After ribB->Divide(4,2); add updates (around line 123)
    if ($lines2[$i] =~ /ribB->Divide\(4,2\);/) {
        print $out2 "  ribA->Update();              // added_AD\n";
        print $out2 "  gSystem->ProcessEvents();    // added_AD\n";
        print $out2 "  ribB->Update();              // added_AD\n";
        print $out2 "  gSystem->ProcessEvents();    // added_AD\n";
    }
    
    # After c->Divide(4,2); add updates (around line 150)
    if ($lines2[$i] =~ /c->Divide\(4,2\);/ && $lines2[$i-1] =~ /TCanvas\* c = new TCanvas/) {
        print $out2 "    c->Update();               // added_AD\n";
        print $out2 "    gSystem->ProcessEvents();  // added_AD\n";
    }
}
close($out2);

print "Modified $file2\n";
print "Done! Changes added with comment: added_AD\n";
