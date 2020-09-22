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
class __TwigTemplate_a5e98ff9f2fe1cf8cbd74c7607e6cd0830b508a6e14573c4830c00057aea526f extends \Twig\Template
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
\t<link rel=\"stylesheet\" href=\"https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css\" integrity=\"sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T\" crossorigin=\"anonymous\">
\t<style>
\t\t.section {
\t\t\tposition: relative;
\t\t\theight: 100vh;
\t\t}

\t\t.section .section-center {
\t\t\tposition: absolute;
\t\t\ttop: 50%;
\t\t\tleft: 0;
\t\t\tright: 0;
\t\t\t-webkit-transform: translateY(-50%);
\t\t\ttransform: translateY(-50%);
\t\t}

\t\t#booking {
\t\t\tfont-family: 'Montserrat', sans-serif;
\t\t\tbackground-image: url('/img/background.jpg');
\t\t\tbackground-size: cover;
\t\t\tbackground-position: center;
\t\t}

\t\t#booking::before {
\t\t\tcontent: '';
\t\t\tposition: absolute;
\t\t\tleft: 0;
\t\t\tright: 0;
\t\t\tbottom: 0;
\t\t\ttop: 0;
\t\t\tbackground: rgba(47, 103, 177, 0.6);
\t\t}

\t\t.booking-form {
\t\t\tbackground-color: #fff;
\t\t\tpadding: 50px 20px;
\t\t\t-webkit-box-shadow: 0px 5px 20px -5px rgba(0, 0, 0, 0.3);
\t\t\tbox-shadow: 0px 5px 20px -5px rgba(0, 0, 0, 0.3);
\t\t\tborder-radius: 4px;
\t\t}

\t\t.booking-form .form-group {
\t\t\tposition: relative;
\t\t\tmargin-bottom: 30px;
\t\t}

\t\t.booking-form .form-control {
\t\t\tbackground-color: #ebecee;
\t\t\tborder-radius: 4px;
\t\t\tborder: none;
\t\t\theight: 40px;
\t\t\t-webkit-box-shadow: none;
\t\t\tbox-shadow: none;
\t\t\tcolor: #3e485c;
\t\t\tfont-size: 14px;
\t\t}

\t\t.booking-form .form-control::-webkit-input-placeholder {
\t\t\tcolor: rgba(62, 72, 92, 0.3);
\t\t}

\t\t.booking-form .form-control:-ms-input-placeholder {
\t\t\tcolor: rgba(62, 72, 92, 0.3);
\t\t}

\t\t.booking-form .form-control::placeholder {
\t\t\tcolor: rgba(62, 72, 92, 0.3);
\t\t}

\t\t.booking-form input[type=\"date\"].form-control:invalid {
\t\t\tcolor: rgba(62, 72, 92, 0.3);
\t\t}

\t\t.booking-form select.form-control {
\t\t\t-webkit-appearance: none;
\t\t\t-moz-appearance: none;
\t\t\tappearance: none;
\t\t}

\t\t.booking-form select.form-control+.select-arrow {
\t\t\tposition: absolute;
\t\t\tright: 0px;
\t\t\tbottom: 4px;
\t\t\twidth: 32px;
\t\t\tline-height: 32px;
\t\t\theight: 32px;
\t\t\ttext-align: center;
\t\t\tpointer-events: none;
\t\t\tcolor: rgba(62, 72, 92, 0.3);
\t\t\tfont-size: 14px;
\t\t}

\t\t.booking-form select.form-control+.select-arrow:after {
\t\t\tcontent: '\\279C';
\t\t\tdisplay: block;
\t\t\t-webkit-transform: rotate(90deg);
\t\t\ttransform: rotate(90deg);
\t\t}

\t\t.booking-form .form-label {
\t\t\tdisplay: inline-block;
\t\t\tcolor: #3e485c;
\t\t\tfont-weight: 700;
\t\t\tmargin-bottom: 6px;
\t\t\tmargin-left: 7px;
\t\t}

\t\t.booking-form .submit-btn {
\t\t\tdisplay: inline-block;
\t\t\tcolor: #fff;
\t\t\tbackground-color: #1e62d8;
\t\t\tfont-weight: 700;
\t\t\tpadding: 14px 30px;
\t\t\tborder-radius: 4px;
\t\t\tborder: none;
\t\t\t-webkit-transition: 0.2s all;
\t\t\ttransition: 0.2s all;
\t\t}

\t\t.booking-form .submit-btn:hover,
\t\t.booking-form .submit-btn:focus {
\t\t\topacity: 0.9;
\t\t}

\t\t.booking-cta {
\t\t\tmargin-top: 80px;
\t\t\tmargin-bottom: 30px;
\t\t}

\t\t.booking-cta h1 {
\t\t\tfont-size: 52px;
\t\t\ttext-transform: uppercase;
\t\t\tcolor: #fff;
\t\t\tfont-weight: 700;
\t\t}

\t\t.booking-cta p {
\t\t\tfont-size: 16px;
\t\t\tcolor: rgba(255, 255, 255, 0.8);
\t\t}
\t</style>
</head>

<body>
\t<div id=\"booking\" class=\"section\">
\t\t<div class=\"section-center\">
\t\t\t<div class=\"container\">
\t\t\t\t<div class=\"row\">
\t\t\t\t\t<div class=\"col-md-7 col-md-push-5\">
\t\t\t\t\t\t<div class=\"booking-cta\">
\t\t\t\t\t\t\t<h1>Make your appointment</h1>
\t\t\t\t\t\t\t<p>It is our vision to be a salon where everyone feels comfortable and convenient. We wis hto perpetuate happiness among our clients and staff.
\t\t\t\t\t\t\t</p>
\t\t\t\t\t\t</div>
\t\t\t\t\t</div>
\t\t\t\t\t<div class=\"col-md-4 col-md-pull-7\">
\t\t\t\t\t\t<div class=\"booking-form\">
\t\t\t\t\t\t\t<form>
\t\t\t\t\t\t\t\t<div class=\"form-group\">
\t\t\t\t\t\t\t\t\t<span class=\"form-label\">Your address</span>
\t\t\t\t\t\t\t\t\t<input class=\"form-control\" type=\"text\" placeholder=\"Enter a destination or hotel name\">
\t\t\t\t\t\t\t\t</div>
\t\t\t\t\t\t\t\t<div class=\"row\">
\t\t\t\t\t\t\t\t\t<div class=\"col-sm-12\">
\t\t\t\t\t\t\t\t\t\t<div class=\"form-group\">
\t\t\t\t\t\t\t\t\t\t\t<span class=\"form-label\">When</span>
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
</html>";
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
