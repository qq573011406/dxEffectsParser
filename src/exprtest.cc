// $Id$

#include <iostream>
#include <fstream>

#include "driver.h"
#include "expression.h"

int main(int argc, char *argv[])
{
    DxEffectsTree calc;
    example::Driver driver(calc);
    bool readfile = false;

    for(int ai = 1; ai < argc; ++ai)
    {
	if (argv[ai] == std::string ("-p")) {
	    driver.trace_parsing = true;
	}
	else if (argv[ai] == std::string ("-s")) {
	    driver.trace_scanning = true;
	}
	else
	{
	    // read a file with expressions

		std::fstream infile(argv[ai]);
	    if (!infile.good())
	    {
		std::cerr << "Could not open file: " << argv[ai] << std::endl;
		return 0;
	    }

	 //   calc.clearExpressions();
	    bool result = driver.parse_stream(infile, argv[ai]);
	    if (result)
		{
			std::cout << "Techniques:" << std::endl;
			auto techiques = calc.getTechiques();
			for (unsigned int ei = 0; ei < techiques.size(); ++ei)
			{
				std::cout << "Technique " << techiques[ei]->getName() << std::endl;
				auto passes = techiques[ei]->getPasses();
				for (unsigned int pi =0;pi<passes.size();pi++)
				{
					std::cout << "\tPass " << (passes[pi]->getName()) << std::endl;
				}
			}
		}
		std::system("pause");
	    readfile = true;
	}
    }
}
