<div class="openpa-panel {$node|access_style}" style="width: 100%">
    
    {attribute_view_gui attribute=$node|attribute('chart') ratio='16:9'}

    <div class="openpa-panel-content">
        <h3 class="Card-title">
            <a class="Card-titleLink" href="{$openpa.content_link.full_link}"
               title="{$node.name|wash()}">{$node.name|wash()}</a>
        </h3>

        <div class="Card-text">
            <p>{$node|abstract()|oc_shorten(150)}</p>
        </div>
    </div>

    <a class="readmore" href="{object_handler($node).content_link.full_link}" title="{$node.name|wash()}">Leggi</a>

</div>
