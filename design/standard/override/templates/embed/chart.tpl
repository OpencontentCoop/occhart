{def $width = "100%"
	 $ratio = '12:9'}
{if and(is_set($object_parameters.align), $object_parameters.align|ne('center'))}
{set $width = "300px"
	 $ratio = '4:3'}
{/if}
{attribute_view_gui attribute=$object|attribute('chart') ratio=$ratio width=$width}  
{undef $width $ratio}