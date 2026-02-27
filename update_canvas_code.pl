#!/usr/bin/env perl
use strict;
use warnings;

# File 1: AcdCalibUtil.cxx
my $file1 = $ARGV[0] || "/sdf/home/a/abhishek/ACD_calib/releases/GR-20-09-10/calibGenACD/src/AcdCalibUtil.cxx";

open(my $fh1, '<', $file1) or die "Cannot open $file1: $!";
my @lines1 = <$fh1>;
close($fh1);

open(my $out1, '>', $file1) or die "Cannot write to $file1: $!";
for (my $i = 0; $i < @lines1; $i++) {
    print $out1 $lines1[$i];
    
    # After gSystem->ProcessEvents() that follows cnv.Update(), add Flush
    if ($lines1[$i] =~ /gSystem->ProcessEvents\(\);\s*\/\/ added_AD/ && 
        $lines1[$i-1] =~ /cnv\.Update\(\)/) {
        # Check if flush is not already added
        if ($i+1 >= @lines1 || $lines1[$i+1] !~ /cnv\.Flush\(\)/) {
            print $out1 "    cnv.Flush();               // added_AD\n";
        }
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
    
    # After topB->Update() and ProcessEvents(), add Flush
    if ($lines2[$i] =~ /topB->Update\(\);\s*\/\/ added_AD/) {
        if ($i+1 < @lines2 && $lines2[$i+1] =~ /gSystem->ProcessEvents/) {
            print $out2 $lines2[++$i];  # print the ProcessEvents line
            # Check if flush is not already added
            if ($i+1 >= @lines2 || $lines2[$i+1] !~ /topB->Flush\(\)/) {
                print $out2 "  topB->Flush();               // added_AD\n";
            }
        }
    }
    
    # After topA->Update() and ProcessEvents(), add Flush (needs to be checked too)
    if ($lines2[$i] =~ /topA->ProcessEvents.*added_AD/) {
        if ($i+1 >= @lines2 || $lines2[$i+1] !~ /topA->Flush\(\)/) {
            print $out2 "  topA->Flush();               // added_AD\n";
        }
    }
    
    # After cB->Update() and ProcessEvents(), add Flush
    if ($lines2[$i] =~ /cB->ProcessEvents.*added_AD/) {
        if ($i+1 >= @lines2 || $lines2[$i+1] !~ /cB->Flush\(\)/) {
            print $out2 "  cB->Flush();                 // added_AD\n";
        }
    }
    
    # After cA ProcessEvents
    if ($lines2[$i] =~ /cA->ProcessEvents.*added_AD/) {
        if ($i+1 >= @lines2 || $lines2[$i+1] !~ /cA->Flush\(\)/) {
            print $out2 "  cA->Flush();                 // added_AD\n";
        }
    }
    
    # After ribB ProcessEvents
    if ($lines2[$i] =~ /ribB->ProcessEvents.*added_AD/) {
        if ($i+1 >= @lines2 || $lines2[$i+1] !~ /ribB->Flush\(\)/) {
            print $out2 "  ribB->Flush();               // added_AD\n";
        }
    }
    
    # After ribA ProcessEvents
    if ($lines2[$i] =~ /ribA->ProcessEvents.*added_AD/) {
        if ($i+1 >= @lines2 || $lines2[$i+1] !~ /ribA->Flush\(\)/) {
            print $out2 "  ribA->Flush();               // added_AD\n";
        }
    }
    
    # After c->ProcessEvents
    if ($lines2[$i] =~ /^\s*c->ProcessEvents.*added_AD/) {
        if ($i+1 >= @lines2 || $lines2[$i+1] !~ /c->Flush\(\)/) {
            print $out2 "    c->Flush();                  // added_AD\n";
        }
    }
}
close($out2);

print "Modified $file2\n";
print "Done! Flush() calls added with comment: added_AD\n";
