%option noyywarp nodefault yylineno case-insensitive

%{

%}


%%

"\begin{document}"      { return INICIO; }
"\fim{document}"        { return FIM; }
"\section"              { return SECTION; }
"\subsection"           { return SUBSECTION; }
"\paragraph"            { return PARAGRAPH; }

%%