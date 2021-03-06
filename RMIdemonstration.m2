restart
needsPackage("Graphics"); needsPackage("TorAlgebra");--, FileName => "~/Desktop/TorAlgebra.m2");
needsPackage("RandomMonomialIdeals", FileName => "~/Desktop/Workshop-2018-Madison/RandomMonomialIdeals/RandomMonomialIdeals.m2")

-- parameters for Erdos-Renyi model
n = 4; -- number of variables
D = 8; -- maximum total degree
p = 2^(-5)//toRR;
N = 10; -- number of samples

-- generating Erdos-Renyi random monomial ideals
IDEALS = randomMonomialIdeals(n, D, p, N) 
netList IDEALS


-- specifying the ring to work in
S = ZZ/7[a, b, c, d]
IDEALS = randomMonomialIdeals(S, D, p, N); netList IDEALS

-- compute statistics about the minimal generators
mingenStats(IDEALS)

-- try a larger sample size
IDEALS = randomMonomialIdeals(S, D, p, 200); 
mingenStats(IDEALS)

-- using the show tally option
mingenStats(IDEALS, ShowTally => true)

-- compare to expected number of (non-minimal) generators
p*binomial(n+D,D)

-- plotting histograms
M_TALLY = (mingenStats(IDEALS, ShowTally => true))_2; -- the tallies we want to plot
DC_TALLY = (mingenStats(IDEALS, ShowTally => true))_5;
M_PLOT = plotTally(M_TALLY, 40.0, 400.0, XAxisLabel => "# mingens"); -- using "Graphics" package
DC_PLOT = plotTally(DC_TALLY, 40.0, 400.0, XAxisLabel => "degree complexity");
svgPicture(M_PLOT, "mingens-histogram.svg"); -- saves histogram to .svg file
svgPicture(DC_PLOT, "degree-complexity-histogram.svg");

-- varying p
-- expected number of generators chosen vs. observed number of minimal generators vs. degree complexity
netList (
    {{"p", "E[#gens chosen]", "observed #mingens", "degree complexity"}} |
    for i from -10 to -1 list(
    	p = 2^i//toRR;
    	I = randomMonomialIdeals(S, D, p, 100);
    	expectedGens = p*binomial(n+D, D);
    	(observedMingens, degreeComplexity) = toSequence(mingenStats(I))_{0,2};
    	{p, expectedGens, observedMingens, degreeComplexity}
	)
    )


-- ---- ------ --------------------------- ------ ---- --
-- ---- ------ -- PROJECTIVE  DIMENSION -- ------ ---- --
-- ---- ------ --------------------------- ------ ---- --


-- what is a minimal free resolution? in one example

I = monomialIdeal(a^5*b^2*c^3, a*c^4*d, a^5*b^2*c*d^2, b*c^2*d^5) 
F_1 = gens I
F_2 = syz(gens I)
F_3 = syz(F_2)
F_4 = syz(F_3)
res I
peek res I

-- Projective dimension = length of a minimal free resolution
res I
pdim (S^1/I)

-- what happens in the random case?
pdimStats(randomMonomialIdeals(3, 10, 0.25, 100), ShowTally => true)

-- varying p
netList{
    {"p"}|0.1*toList(0..10),
    {"E[pdim]"}|for i from 0 to 10 list(
    	p = i*0.1;
    	I = randomMonomialIdeals(3, 10, p, 100);
    	(pdimStats(I))_0	
    	--(pdimStats(I, ShowTally => true))_(-1) --to see tally instead
    	)
    }

-- another model: degree D generators only

pList = (for i from 1 to 9 list 0.0)|{0.25}
randomMonomialIdeals(3, 10, pList, 10)

-- varying p
netList{
    {"p"}|0.1*toList(0..10),
    {"E[pdim]"}|for i from 0 to 10 list(
	pList = (for i from 1 to 9 list 0.0)|{i*0.1};
    	I = randomMonomialIdeals(3, 10, pList, 10);
    	(pdimStats(I))_0	
    	)
    }
    
    

