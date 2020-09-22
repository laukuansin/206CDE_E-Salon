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
class __TwigTemplate_58ab7176c764abc071095edbb51bde692920e6edede57ae25b0e4078cc06bb47 extends \Twig\Template
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

\t<!-- Bootstrap -->
\t<link type=\"text/css\" rel=\"stylesheet\" href=\"css/bootstrap.min.css\" />

\t<!-- Custom stlylesheet -->
\t<link type=\"text/css\" rel=\"stylesheet\" href=\"css/style.css\" />
<link rel=\"stylesheet\" href=\"https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css\" integrity=\"sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T\" crossorigin=\"anonymous\">
\t<style>
\t\t.section {
\tposition: relative;
\theight: 100vh;
}

.section .section-center {
\tposition: absolute;
\ttop: 50%;
\tleft: 0;
\tright: 0;
\t-webkit-transform: translateY(-50%);
\ttransform: translateY(-50%);
}

#booking {
\tfont-family: 'Montserrat', sans-serif;
\tbackground-image: url('/img/background.jpg');
\tbackground-size: cover;
\tbackground-position: center;
}

#booking::before {
\tcontent: '';
\tposition: absolute;
\tleft: 0;
\tright: 0;
\tbottom: 0;
\ttop: 0;
\tbackground: rgba(47, 103, 177, 0.6);
}

.booking-form {
\tbackground-color: #fff;
\tpadding: 50px 20px;
\t-webkit-box-shadow: 0px 5px 20px -5px rgba(0, 0, 0, 0.3);
\tbox-shadow: 0px 5px 20px -5px rgba(0, 0, 0, 0.3);
\tborder-radius: 4px;
}

.booking-form .form-group {
\tposition: relative;
\tmargin-bottom: 30px;
}

.booking-form .form-control {
\tbackground-color: #ebecee;
\tborder-radius: 4px;
\tborder: none;
\theight: 40px;
\t-webkit-box-shadow: none;
\tbox-shadow: none;
\tcolor: #3e485c;
\tfont-size: 14px;
}

.booking-form .form-control::-webkit-input-placeholder {
\tcolor: rgba(62, 72, 92, 0.3);
}

.booking-form .form-control:-ms-input-placeholder {
\tcolor: rgba(62, 72, 92, 0.3);
}

.booking-form .form-control::placeholder {
\tcolor: rgba(62, 72, 92, 0.3);
}

.booking-form input[type=\"date\"].form-control:invalid {
\tcolor: rgba(62, 72, 92, 0.3);
}

.booking-form select.form-control {
\t-webkit-appearance: none;
\t-moz-appearance: none;
\tappearance: none;
}

.booking-form select.form-control+.select-arrow {
\tposition: absolute;
\tright: 0px;
\tbottom: 4px;
\twidth: 32px;
\tline-height: 32px;
\theight: 32px;
\ttext-align: center;
\tpointer-events: none;
\tcolor: rgba(62, 72, 92, 0.3);
\tfont-size: 14px;
}

.booking-form select.form-control+.select-arrow:after {
\tcontent: '\\279C';
\tdisplay: block;
\t-webkit-transform: rotate(90deg);
\ttransform: rotate(90deg);
}

.booking-form .form-label {
\tdisplay: inline-block;
\tcolor: #3e485c;
\tfont-weight: 700;
\tmargin-bottom: 6px;
\tmargin-left: 7px;
}

.booking-form .submit-btn {
\tdisplay: inline-block;
\tcolor: #fff;
\tbackground-color: #1e62d8;
\tfont-weight: 700;
\tpadding: 14px 30px;
\tborder-radius: 4px;
\tborder: none;
\t-webkit-transition: 0.2s all;
\ttransition: 0.2s all;
}

.booking-form .submit-btn:hover,
.booking-form .submit-btn:focus {
\topacity: 0.9;
}

.booking-cta {
\tmargin-top: 80px;
\tmargin-bottom: 30px;
}

.booking-cta h1 {
\tfont-size: 52px;
\ttext-transform: uppercase;
\tcolor: #fff;
\tfont-weight: 700;
}

.booking-cta p {
\tfont-size: 16px;
\tcolor: rgba(255, 255, 255, 0.8);
}
\t</style>
</head>

<body>
\t<div id=\"booking\" class=\"section\">
\t\t<div class=\"section-center\">
\t\t\t<div class=\"container\">
\t\t\t\t<div class=\"row\">
\t\t\t\t\t<div class=\"col-md-7 col-md-push-5\">
\t\t\t\t\t\t<div class=\"booking-cta\">
\t\t\t\t\t\t\t<h1>Make your reservation</h1>
\t\t\t\t\t\t\t<p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Animi facere, soluta magnam consectetur molestias itaque
\t\t\t\t\t\t\t\tad sint fugit architecto incidunt iste culpa perspiciatis possimus voluptates aliquid consequuntur cumque quasi.
\t\t\t\t\t\t\t\tPerspiciatis.
\t\t\t\t\t\t\t</p>
\t\t\t\t\t\t</div>
\t\t\t\t\t</div>
\t\t\t\t\t<div class=\"col-md-4 col-md-pull-7\">
\t\t\t\t\t\t<div class=\"booking-form\">
\t\t\t\t\t\t\t<form>
\t\t\t\t\t\t\t\t<div class=\"form-group\">
\t\t\t\t\t\t\t\t\t<span class=\"form-label\">Your Destination</span>
\t\t\t\t\t\t\t\t\t<input class=\"form-control\" type=\"text\" placeholder=\"Enter a destination or hotel name\">
\t\t\t\t\t\t\t\t</div>
\t\t\t\t\t\t\t\t<div class=\"row\">
\t\t\t\t\t\t\t\t\t<div class=\"col-sm-6\">
\t\t\t\t\t\t\t\t\t\t<div class=\"form-group\">
\t\t\t\t\t\t\t\t\t\t\t<span class=\"form-label\">Check In</span>
\t\t\t\t\t\t\t\t\t\t\t<input class=\"form-control\" type=\"date\" required>
\t\t\t\t\t\t\t\t\t\t</div>
\t\t\t\t\t\t\t\t\t</div>
\t\t\t\t\t\t\t\t\t<div class=\"col-sm-6\">
\t\t\t\t\t\t\t\t\t\t<div class=\"form-group\">
\t\t\t\t\t\t\t\t\t\t\t<span class=\"form-label\">Check out</span>
\t\t\t\t\t\t\t\t\t\t\t<input class=\"form-control\" type=\"date\" required>
\t\t\t\t\t\t\t\t\t\t</div>
\t\t\t\t\t\t\t\t\t</div>
\t\t\t\t\t\t\t\t</div>
\t\t\t\t\t\t\t\t<div class=\"row\">
\t\t\t\t\t\t\t\t\t<div class=\"col-sm-4\">
\t\t\t\t\t\t\t\t\t\t<div class=\"form-group\">
\t\t\t\t\t\t\t\t\t\t\t<span class=\"form-label\">Rooms</span>
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

</html>
?>";
    }

    public function getTemplateName()
    {
        return "default/template/appointment/make_appointment.twig";
    }

    public function getDebugInfo()
    {
        return array (  37 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "default/template/appointment/make_appointment.twig", "");
    }
}
