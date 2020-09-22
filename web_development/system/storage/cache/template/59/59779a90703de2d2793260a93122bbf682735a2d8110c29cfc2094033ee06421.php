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

/* default/template/common/header.twig */
class __TwigTemplate_3cf94d5a36cf319cf89c47571e96ce28d333a6512b0fc23d4a0575934c9ec2cd extends \Twig\Template
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
        echo "<nav class=\"navbar navbar-expand-lg navbar-light fixed-top py-3\" id=\"mainNav\">
  <div class=\"container\">
      <a class=\"navbar-brand js-scroll-trigger\" href=\"#page-top\">Start Bootstrap</a>
      <button class=\"navbar-toggler navbar-toggler-right\" type=\"button\" data-toggle=\"collapse\" data-target=\"#navbarResponsive\" aria-controls=\"navbarResponsive\" aria-expanded=\"false\" aria-label=\"Toggle navigation\"><span class=\"navbar-toggler-icon\"></span></button>
      <div class=\"collapse navbar-collapse\" id=\"navbarResponsive\">
          <ul class=\"navbar-nav ml-auto my-2 my-lg-0\">
              <li class=\"nav-item\"><a class=\"nav-link js-scroll-trigger\" href=\"#about\">About</a></li>
              <li class=\"nav-item\"><a class=\"nav-link js-scroll-trigger\" href=\"#services\">Services</a></li>
              <li class=\"nav-item\"><a class=\"nav-link js-scroll-trigger\" href=\"#portfolio\">Portfolio</a></li>
              <li class=\"nav-item\"><a class=\"nav-link js-scroll-trigger\" href=\"#contact\">Contact</a></li>
          </ul>
      </div>
  </div>
</nav>";
    }

    public function getTemplateName()
    {
        return "default/template/common/header.twig";
    }

    public function getDebugInfo()
    {
        return array (  37 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "default/template/common/header.twig", "");
    }
}
