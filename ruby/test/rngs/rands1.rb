
$standardRand =
  proc { ||
    rand
}


# "Box-Muller transformation", see http://www.taygeta.com/random/gaussian.html
$gaussRand =
  proc { ||
    begin
      x1 = 2.0 * rand - 1.0;
      x2 = 2.0 * rand - 1.0;
      w = x1 * x1 + x2 * x2;
    end until ( w < 1.0 );
  w = Math.sqrt( (-2.0 * Math.log( w ) ) / w );
  x1 * w;
}


def boundedRand(rand, lowerBound, upperBound)
  proc { ||
      begin
	r=rand.call()
      end until (r>lowerBound) and (r<upperBound)
    r
  }
end


def shiftedRand(rand, shift)
  proc { ||
      rand.call() + shift
  }
end


def scaledRand(rand, scale)
  proc { ||
      rand.call() * scale
  }
end


def calcRandHistogram(rand, lowerBound, upperBound, nSections, nRuns)
  bRand = boundedRand(rand, lowerBound, upperBound)
  sectionWidth = (upperBound - lowerBound) / nSections

  result = (0...nSections).collect {|i| [lowerBound + i*sectionWidth, 0]}

  nRuns.times { |i|
    r = bRand.call
    result[(r-lowerBound)/sectionWidth][1] += 1
  }

  result
end

