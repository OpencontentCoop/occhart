<div class="openpa-carousel">
    <div class="Hero">

        <div class="Hero-image">
          {attribute_view_gui attribute=$node|attribute('chart') ratio='20:9'}            
        </div>

        <div class="Hero-content carousel-caption">
            <p class="u-padding-r-bottom u-padding-r-top u-text-r-xs u-xs-hidden">
                <a href="{$node.parent.url_alias|ezurl(no)}" class="u-textClean u-color-60 u-text-h4"><span class="Dot u-background-60"></span>{$node.parent.name|wash()}</a>
            </p>
            <h3 class="u-text-h2"><a href="{$openpa.content_link.full_link}" class="u-color-95 u-textClean">{$node.name|wash()}</a></h3>
            <p class="u-padding-r-bottom u-padding-r-top u-text-p u-margin-r-bottom">{$node|abstract()|openpa_shorten(200)}</p>
        </div>
    </div>
</div>
