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

/* default/template/common/home.twig */
class __TwigTemplate_2204d0aa11a3e4db7f1856da2ae1d42831effd7026490ef21945e5797fecd4bf extends \Twig\Template
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
        echo "
<!DOCTYPE html>
<html lang=\"en\">
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
    </head>
    <body id=\"page-top\">
        <!-- Navigation-->
        ";
        // line 24
        echo ($context["header"] ?? null);
        echo "
        <!-- Masthead-->
        <header class=\"masthead\">
            <div class=\"container h-100\">
                <div class=\"row h-100 align-items-center justify-content-center text-center\">
                    <div class=\"col-lg-10 align-self-end\">
                        <h1 class=\"text-uppercase text-white font-weight-bold\">Malaysia Top 1 Hair Salon</h1>
                        <hr class=\"divider my-4\" />
                    </div>
                    <div class=\"col-lg-8 align-self-baseline\">
                        <p class=\"text-white-75 font-weight-light mb-5\">A person who cuts his hair here is about to change his life</p>
                        <a class=\"btn btn-primary btn-xl js-scroll-trigger\" href=\"#about\">Find Out More</a>
                    </div>
                </div>
            </div>
        </header>
        <!-- About-->
        <section class=\"page-section bg-primary\" id=\"about\">
            <div class=\"container\">
                <div class=\"row justify-content-center\">
                    <div class=\"col-lg-8 text-center\">
                        <h2 class=\"text-white mt-0\">We've got what you need!</h2>
                        <hr class=\"divider light my-4\" />
                        <p class=\"text-white-50 mb-4\">It is our vision to be a salon where everyone feels comfortable and convenient. We wish to perpetuate happiness among our clients and staff!</p>
                        <a class=\"btn btn-light btn-xl js-scroll-trigger\" href=\"#services\">Get Started!</a>
                    </div>
                </div>
            </div>
        </section>
        <!-- Services-->
        <section class=\"page-section pb-0\" id=\"services\">
                    <div id=\"portfolio\">
<div class=\"container-fluid p-0\">
    <h2 class=\"text-center mt-0\">Our Service</h2>
    <hr class=\"divider my-4\" />
                <div class=\"row no-gutters\">
                    <div class=\"col-lg-4 col-sm-6\">
                        <a class=\"portfolio-box\" href=\"assets/img/portfolio/fullsize/1.jpg\">
                            <img class=\"img-fluid\" src=\"";
        // line 62
        echo ($context["img_hair_service"] ?? null);
        echo "\" alt=\"\"/>
                            <div class=\"portfolio-box-caption\">
                                <!-- <div class=\"project-category text-white-50\">Hair</div> -->
                                <div class=\"project-name\"><h1>Hair</h1></div>
                            </div>
                        </a>
                    </div>
                    <div class=\"col-lg-4 col-sm-6\">
                        <a class=\"portfolio-box\" href=\"assets/img/portfolio/fullsize/1.jpg\">
                            <img class=\"img-fluid\" src=\"";
        // line 71
        echo ($context["img_scalp_service"] ?? null);
        echo "\" alt=\"\"/>
                            <div class=\"portfolio-box-caption\">
                                <div class=\"project-name\"><h1>Scalp</h1></div>
                            </div>
                        </a>
                    </div>
                    <div class=\"col-lg-4 col-sm-6\">
                        <a class=\"portfolio-box\" href=\"assets/img/portfolio/fullsize/1.jpg\">
                            <img class=\"img-fluid\" src=\"";
        // line 79
        echo ($context["img_nail_service"] ?? null);
        echo "\" alt=\"\"/>
                            <div class=\"portfolio-box-caption\">
                                <div class=\"project-name\"><h1>Nail</h1></div>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>
        <!-- Call to action-->
        <section class=\"page-section bg-dark text-white\">
            <div class=\"container\">
                <div class=\"row justify-content-center\">
                    <div class=\"col-lg-8 text-center\">
                        <h2 class=\"mt-0\">Let's Get In Touch!</h2>
                        <hr class=\"divider my-4\" />
                        <p class=\"text-muted mb-5\">Ready to cut your hair hear? Give us a call or make an appointment with us. We will get back to you as soon as possible</p>
                    </div>
                </div>
                <div class=\"row\">
                    <div class=\"col-lg-4 ml-auto text-center mb-5 mb-lg-0\">
                        <i class=\"fas fa-phone fa-3x mb-3 text-muted\"></i>
                        <div>012-4727438</div>
                    </div>
                    <div class=\"col-lg-4 mr-auto text-center\">
                        <i class=\"fas fa-calendar-check fa-3x mb-3 text-muted\"></i>
                        <!-- Make sure to change the email address in BOTH the anchor text and the link target below!-->
                        <a class=\"d-block\" href=\"";
        // line 107
        echo ($context["appointment"] ?? null);
        echo "\">Appointment now</a>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer-->
        ";
        // line 114
        echo ($context["footer"] ?? null);
        echo "
        <!-- Bootstrap core JS-->
        <script src=\"https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js\"></script>
        <script src=\"https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.bundle.min.js\"></script>
        <!-- Third party plugin JS-->
        <script src=\"https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.4.1/jquery.easing.min.js\"></script>
        <script src=\"https://cdnjs.cloudflare.com/ajax/libs/magnific-popup.js/1.1.0/jquery.magnific-popup.min.js\"></script>
        <!-- Core theme JS-->
        <script src=\"catalog/view/javascript/myproj/home.js\" type=\"text/javascript\"></script>
    </body>
</html>

";
    }

    public function getTemplateName()
    {
        return "default/template/common/home.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  167 => 114,  157 => 107,  126 => 79,  115 => 71,  103 => 62,  62 => 24,  37 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "default/template/common/home.twig", "");
    }
}
