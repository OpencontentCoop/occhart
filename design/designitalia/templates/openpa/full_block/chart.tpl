<div class="openpa-widget {$block.view} {if and(is_set($block.custom_attributes.color_style), $block.custom_attributes.color_style|ne(''))}color color-{$block.custom_attributes.color_style}{/if} u-margin-top-m">

    <div class="openpa-widget-content">
        <section class="Grid">
            <div class="Grid-cell u-sizeFull u-md-size1of2 u-lg-size1of2 u-text-r-s u-padding-r-top u-padding-r-bottom">
              <div class="u-text-r-m u-layout-prose u-layout-withGutter">
                <h3 class="u-text-h3 u-margin-r-bottom">
                      {$node.name|wash()}
                </h3>
                <div class="u-textSecondary u-lineHeight-l">
                    {$node|abstract()}
                </div>
                <a class="readmore" href="{$openpa.content_link.full_link}" title="{$node.name|wash()}">Leggi</a>
              </div>
            </div>

            <div class="Grid-cell u-sizeFull u-md-size1of2 u-lg-size1of2 u-text-r-s">
              <div class="openpa-panel-image">
                  {attribute_view_gui attribute=$node|attribute('chart') ratio='4:3'}
              </div>
            </div>          
        </section>
    </div>
</div>
