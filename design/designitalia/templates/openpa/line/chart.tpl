<div class="openpa-line class-{$node.class_identifier} media {$node|access_style}">

    <div class="media-image">
        {attribute_view_gui attribute=$node|attribute('chart') ratio='4:3' width="200px" show_title=false() show_legend=false()}
    </div>

    <div class="media-body">
        <h3 class="media-heading">
            <a href="{$openpa.content_link.full_link}">{$node.name|wash()}</a>
        </h3>

        {if $openpa.content_line.has_content}
          <ul class="media-details">
            {foreach $openpa.content_line.attributes as $openpa_attribute}
              <li>
                {if $openpa_attribute.line.show_label}
                 <strong>{$openpa_attribute.label}:</strong>
                {/if}
                {attribute_view_gui attribute=$openpa_attribute.contentobject_attribute href=cond($openpa_attribute.line.show_link|not, 'no-link', '')}
              </li>
            {/foreach}
          </ul>

        {/if}

    </div>
</div>
