# Create your models here.
from django.db import models
from django.utils.translation import ugettext_lazy as _
from mezzanine.pages.models import Page, RichText

class CommunityPage(Page, RichText):
    """
    A doc tree page
    """
    add_toc = models.BooleanField(_("Add TOC"), default=False,
                                  help_text=_("Include a list of child links"))

    class Meta:
        verbose_name = _("Community Page")
        verbose_name_plural = _("Community Pages")