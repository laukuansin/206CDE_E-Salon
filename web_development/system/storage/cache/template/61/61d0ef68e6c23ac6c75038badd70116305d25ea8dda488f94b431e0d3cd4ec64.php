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
class __TwigTemplate_239afd150443ca621041f711d2851babc8c3aca90ce33cad9e2d32a790751e3a extends \Twig\Template
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
        echo "<html>
  <!--Navbar -->
    <nav class=\"mb-1 navbar navbar-expand-lg navbar-dark info-color\">
      <a class=\"navbar-brand\" href=\"#\">Navbar</a>
      <button class=\"navbar-toggler\" type=\"button\" data-toggle=\"collapse\" data-target=\"#navbarSupportedContent-4\" aria-controls=\"navbarSupportedContent-4\" aria-expanded=\"false\" aria-label=\"Toggle navigation\">
        <span class=\"navbar-toggler-icon\"></span>
      </button>
      <div class=\"collapse navbar-collapse\" id=\"navbarSupportedContent-4\">
        <ul class=\"navbar-nav ml-auto\">
          <li class=\"nav-item active\">
            <a class=\"nav-link waves-effect waves-light\" href=\"#\">
              <i class=\"fas fa-envelope\"></i> Contact
              <span class=\"sr-only\">(current)</span>
            </a>
          </li>
          <li class=\"nav-item\">
            <a class=\"nav-link waves-effect waves-light\" href=\"#\">
              <i class=\"fas fa-gear\"></i> Settings</a>
          </li>
          <li class=\"nav-item dropdown\">
            <a class=\"nav-link dropdown-toggle waves-effect waves-light\" id=\"navbarDropdownMenuLink-4\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"false\">
              <i class=\"fas fa-user\"></i> Profile </a>
            <div class=\"dropdown-menu dropdown-menu-right dropdown-info\" aria-labelledby=\"navbarDropdownMenuLink-4\">
              <a class=\"dropdown-item waves-effect waves-light\" href=\"#\">My account</a>
              <a class=\"dropdown-item waves-effect waves-light\" href=\"#\">Log out</a>
            </div>
          </li>
        </ul>
      </div>
    </nav>
    <!--/.Navbar -->
    </html>";
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
