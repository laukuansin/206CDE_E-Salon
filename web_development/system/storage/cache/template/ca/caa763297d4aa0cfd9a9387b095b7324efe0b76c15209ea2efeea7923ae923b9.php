<?php

use Twig\Environment;
use Twig\Error\LoaderError;
use Twig\Error\RuntimeError;
use Twig\Extension\SandboxExtension;
use Twig\Markup;
use Twig\Sandbox\SecurityError;
use Twig\Sandbox\SecurityNotAllowedTagError;
use Twig\Sandbox\SecurityNotAllowedFilterError;
use Twig\Sandbox\SecurityNotAllowedFunctionError;
use Twig\Source;
use Twig\Template;

/* default/template/appointment/make_appointment.twig */
class __TwigTemplate_64c6be7acd168c6461d690102eaa6b6e3e973097321c0996aeea3509f99d5444 extends \Twig\Template
{
    private $source;
    private $macros = [];

    public function __construct(Environment $env)
    {
        parent::__construct($env);

        $this->source = $this->getSourceContext();

        $this->parent = false;

        $this->blocks = [
        ];
    }

    protected function doDisplay(array $context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 1
        echo "<!DOCTYPE html>
<html lang=\"en\">

<head>
\t<meta charset=\"utf-8\">
\t<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
\t<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->

\t<title>Booking Form HTML Template</title>

\t<!-- Google font -->
\t<link href=\"https://fonts.googleapis.com/css?family=Montserrat:400,700\" rel=\"stylesheet\">

\t<link rel=\"stylesheet\" href=\"https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css\" integrity=\"sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T\" crossorigin=\"anonymous\">
\t<style>

\t</style>
</head>

<body>
\t";
        // line 22
        echo ($context["header"] ?? null);
        echo "
\t<div class=\"section masthead\">
\t\t<div class=\"section-center\">
\t\t\t<div class=\"container\">
\t\t\t\t<div class=\"row\">
\t\t\t\t\t<div class=\"col-md-7 col-md-push-5\">
\t\t\t\t\t\t<div class=\"booking-cta\">
\t\t\t\t\t\t\t<h1>Make your appointment</h1>
\t\t\t\t\t\t\t<p>It is our vision to be a salon where everyone feels comfortable and convenient. We wish to perpetuate happiness among our clients and staff.
\t\t\t\t\t\t\t</p>
\t\t\t\t\t\t</div>
\t\t\t\t\t</div>
\t\t\t\t\t<div class=\"col-md-4 col-md-pull-7\">
\t\t\t\t\t\t<div class=\"booking-form\">
\t\t\t\t\t\t\t<form>
\t\t\t\t\t\t\t\t<div class=\"form-group\">
\t\t\t\t\t\t\t\t\t<span class=\"form-label\">Your address</span>
\t\t\t\t\t\t\t\t\t<input class=\"form-control\" type=\"text\" placeholder=\"Enter your address\">
\t\t\t\t\t\t\t\t</div>
\t\t\t\t\t\t\t\t<div class=\"row\">
\t\t\t\t\t\t\t\t\t<div class=\"col-sm-12\">
\t\t\t\t\t\t\t\t\t\t<div class=\"form-group\">
\t\t\t\t\t\t\t\t\t\t\t<span class=\"form-label\">When</span>
\t\t\t\t\t\t\t\t\t\t\t<input class=\"form-control\" type=\"date\" required>
\t\t\t\t\t\t\t\t\t\t</div>
\t\t\t\t\t\t\t\t\t</div>
\t\t\t\t\t\t\t\t</div>
\t\t\t\t\t\t\t\t<div class=\"row form-label
\t\t\t\t\t\t\t\t\">Pax</div>
\t\t\t\t\t\t\t\t<div class=\"row\">
\t\t\t\t\t\t\t\t\t<div class=\"col-sm-4\">
\t\t\t\t\t\t\t\t\t\t<div class=\"form-group\">
\t\t\t\t\t\t\t\t\t\t\t<span class=\"form-label\">Adults</span>
\t\t\t\t\t\t\t\t\t\t\t<select class=\"form-control\">
\t\t\t\t\t\t\t\t\t\t\t\t<option>1</option>
\t\t\t\t\t\t\t\t\t\t\t\t<option>2</option>
\t\t\t\t\t\t\t\t\t\t\t\t<option>3</option>
\t\t\t\t\t\t\t\t\t\t\t</select>
\t\t\t\t\t\t\t\t\t\t\t<span class=\"select-arrow\"></span>
\t\t\t\t\t\t\t\t\t\t</div>
\t\t\t\t\t\t\t\t\t</div>
\t\t\t\t\t\t\t\t\t<div class=\"col-sm-4\">
\t\t\t\t\t\t\t\t\t\t<div class=\"form-group\">
\t\t\t\t\t\t\t\t\t\t\t<span class=\"form-label\">Children</span>
\t\t\t\t\t\t\t\t\t\t\t<select class=\"form-control\">
\t\t\t\t\t\t\t\t\t\t\t\t<option>0</option>
\t\t\t\t\t\t\t\t\t\t\t\t<option>1</option>
\t\t\t\t\t\t\t\t\t\t\t\t<option>2</option>
\t\t\t\t\t\t\t\t\t\t\t</select>
\t\t\t\t\t\t\t\t\t\t\t<span class=\"select-arrow\"></span>
\t\t\t\t\t\t\t\t\t\t</div>
\t\t\t\t\t\t\t\t\t</div>
\t\t\t\t\t\t\t\t</div>
\t\t\t\t\t\t\t\t<div class=\"form-btn\">
\t\t\t\t\t\t\t\t\t<button class=\"submit-btn\">Check availability</button>
\t\t\t\t\t\t\t\t</div>
\t\t\t\t\t\t\t</form>
\t\t\t\t\t\t</div>
\t\t\t\t\t</div>
\t\t\t\t</div>
\t\t\t</div>
\t\t</div>
\t</div>
</body><!-- This templates was made by Colorlib (https://colorlib.com) -->
</html>";
    }

    public function getTemplateName()
    {
        return "default/template/appointment/make_appointment.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  60 => 22,  37 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "default/template/appointment/make_appointment.twig", "");
    }
}
