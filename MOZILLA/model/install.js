var err = initInstall("Corretor para Portugues de Portugal",
                      "pt-PT@dictionaries.addons.mozilla.org", "<% version %>");
if (err != SUCCESS)
    cancelInstall();

var fProgram = getFolder("Program");
err = addDirectory("", "pt-PT@dictionaries.addons.mozilla.org",
		   "dictionaries", fProgram, "dictionaries", true);
if (err != SUCCESS)
    cancelInstall();

performInstall();
