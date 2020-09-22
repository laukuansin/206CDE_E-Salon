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

/* default/template/common/header_home.twig */
class __TwigTemplate_045cda4ee7bed3e093c2d45ad3355e2a31bbebbe040f1cc41020ac92f100e014 extends \Twig\Template
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
        echo "<html lang=\"en\">
    <head>
        <meta charset=\"utf-8\" />
        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1, shrink-to-fit=no\" />
        <meta name=\"description\" content=\"\" />
        <meta name=\"author\" content=\"\" />
        <title>E-Box Salon</title>
        <!-- Favicon-->
        <link rel=\"icon\" type=\"image/x-icon\" href=\"assets/img/favicon.ico\" />
        <!-- Font Awesome icons (free version)-->
        <script src=\"https://use.fontawesome.com/releases/v5.13.0/js/all.js\" crossorigin=\"anonymous\"></script>
        <!-- Google fonts-->
        <link href=\"https://fonts.googleapis.com/css?family=Merriweather+Sans:400,700\" rel=\"stylesheet\" />
        <link href=\"https://fonts.googleapis.com/css?family=Merriweather:400,300,300italic,400italic,700,700italic\" rel=\"stylesheet\" type=\"text/css\" />
        <!-- Third party plugin CSS-->
        <link href=\"https://cdnjs.cloudflare.com/ajax/libs/magnific-popup.js/1.1.0/magnific-popup.min.css\" rel=\"stylesheet\" />
        <!-- Core theme CSS (includes Bootstrap)-->
        <link href=\"catalog/view/stylesheet/myproj/home.css\" rel=\"stylesheet\" />
        <style>    
  </style>
    </head>
    <body>
<nav class=\"navbar navbar-expand-lg navbar-light fixed-top py-3\" id=\"mainNav\">
  <div class=\"container\">
      <a class=\"navbar-brand js-scroll-trigger\" href=\"";
        // line 25
        echo ($context["home"] ?? null);
        echo "\">E-Box Salon</a>
      <button class=\"navbar-toggler navbar-toggler-right\" type=\"button\" data-toggle=\"collapse\" data-target=\"#navbarResponsive\" aria-controls=\"navbarResponsive\" aria-expanded=\"false\" aria-label=\"Toggle navigation\"><span class=\"navbar-toggler-icon\"></span></button>
      <div class=\"collapse navbar-collapse\" id=\"navbarResponsive\">
          <ul class=\"navbar-nav ml-auto my-2 my-lg-0\">
            ";
        // line 29
        if (($context["logged"] ?? null)) {
            // line 30
            echo "              <li class=\"nav-item\"><a class=\"nav-link js-scroll-trigger\" href=\"";
            echo ($context["appointment"] ?? null);
            echo "\">Appointment</a></li>
              <li class=\"nav-item dropdown\">
              <a class=\"nav-link dropdown-toggle\" href=\"#\" id=\"navbardrop\" data-toggle=\"dropdown\">
                Account
              </a>
              <div class=\"dropdown-menu\">
                <a class=\"dropdown-item\" href=\"";
            // line 36
            echo ($context["account"] ?? null);
            echo "\">My Account</a>
                <a class=\"dropdown-item\" href=\"";
            // line 37
            echo ($context["logout"] ?? null);
            echo "\">Logout</a>
              </div>
              </li>
              
            ";
        } else {
            // line 42
            echo "            <li class=\"nav-item\"><a class=\"nav-link js-scroll-trigger\" href=\"";
            echo ($context["register"] ?? null);
            echo "\">Register</a></li>
            <li class=\"nav-item\"><a class=\"nav-link js-scroll-trigger\" href=\"";
            // line 43
            echo ($context["login"] ?? null);
            echo "\">Login</a></li>

            ";
        }
        // line 46
        echo "          </ul>
      </div>
  </div>
</nav>
</body>
</html>
";
    }

    public function getTemplateName()
    {
        return "default/template/common/header_home.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  105 => 46,  99 => 43,  94 => 42,  86 => 37,  82 => 36,  72 => 30,  70 => 29,  63 => 25,  37 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "default/template/common/header_home.twig", "");
    }
}
