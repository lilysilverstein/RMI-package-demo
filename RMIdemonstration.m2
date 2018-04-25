restart
needsPackage("RandomMonomialIdeals", FileName => "~/Desktop/Workshop-2018-Madison/RandomMonomialIdeals/RandomMonomialIdeals.m2")
needsPackage("Graphics")

-- parameters for Erdos-Renyi model
n = 4; -- number of variables
D = 8; -- maximum total degree
p = 2^(-5)//toRR;
N = 10; -- number of samples

-- generating Erdos-Renyi random monomial ideals
IDEALS = randomMonomialIdeals(n, D, p, N) 
netList apply(IDEALS, entries@@mingens) -- better readability

-- specifying the ring to work in
S = ZZ/7[a, b, c, d];
IDEALS = randomMonomialIdeals(S, D, p, N); netList apply(IDEALS, entries@@mingens)

-- compute statistics about the minimal generators
mingenStats(IDEALS)

-- using the show tally option
mingenStats(IDEALS, ShowTally => true)

-- expected number of generators chosen vs. observed number of minimal generators
netList (
    {{"p","exp. # gens chosen","observed # mingens"}} |
    for i from -10 to -1 list(
    	p = 2^i//toRR;
    	IDEALS = randomMonomialIdeals(S,D,p,100);
    	expectedGens = p*binomial(n+D,D);
    	observedMingens = (mingenStats(IDEALS))_0;
    	{p, expectedGens, observedMingens}
	)
    )

-- automatically creating histograms
M_TALLY = (mingenStats(IDEALS, ShowTally => true))_2; -- the tallies we want to plot
DC_TALLY = (mingenStats(IDEALS, ShowTally => true))_5;
M_PLOT = plotTally(M_TALLY, 40.0, 160.0, XAxisLabel => "# mingens"); -- using "Graphics" package
DC_PLOT = plotTally(DC_TALLY, 40.0, 160.0, XAxisLabel => "degree complexity");
svgPicture(M_PLOT, "~/Desktop/mingens-histogram.svg"); -- saves histogram to .svg file
svgPicture(DC_PLOT, "~/Desktop/degree-complexity-histogram.svg");

