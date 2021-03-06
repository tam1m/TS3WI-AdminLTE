{if isset($permoverview['b_virtualserver_log_view']) AND empty($permoverview['b_virtualserver_log_view'])}
<section class="content container-fluid">
	<div class="row">
		<div class="col-xs-12 col-xs-offset-0 col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3 col-lg-4 col-lg-offset-4">
			<div class="box box-danger">
				<div class="box-header"><h3 class="box-title">{$lang['error']}</h3></div>
				<div class="box-body">
					<p class="lead">{$lang['nopermissions']}</p>
				</div>
			</div>
		</div>
	</div>
</section>
{else}
<script>
	$(function () {
		var table = $("#traffic").DataTable({
			"language": {
				"url": dataTableLang
			},
            "autoWidth": false,
			"order": [[ 0, "desc" ]],
			"columnDefs": [
				{ targets: 0, responsivePriority: 1},
				{ targets: 4, responsivePriority: 2},
				{ targets: 'no-sort', orderable: false },
				{ targets: 'no-search', searchable: false }
			],
			"processing": true,
			initComplete: function() {
				var api = this.api();

				new $.fn.dataTable.Buttons(api, {
					"buttons": [
						{
							text: "{$lang['showmoreentrys']}",
							className: "btn btn-primary btn-flat btn_showmoreentrys",
							action: function ( e, dt, node, config ) {
								add_entries();
							}
						}
					]
				});

				$('#traffic_length').parent('.col-sm-6').removeClass('col-sm-6').addClass('col-sm-6 col-md-4');
				$('#traffic_filter').parent('.col-sm-6').removeClass('col-sm-6').addClass('col-sm-6 col-md-4 col-md-push-4').after('<div class="col-sm-12 col-md-4 col-md-pull-4 text-center"><div id="traffic_buttons"></div></div>');		
				$('#traffic_processing').css('top', '7%');
				$('.pagination').addClass('pagination-flat');
				api.buttons().container().prependTo( '#traffic_buttons' );
				$('#traffic_wrapper .row:eq(0) .col-sm-4')
			}
		});
		
		$(window).resize(function(){
	        $("#traffic").css('width', '100%');
	        $("#traffic").DataTable().columns.adjust().draw();
		});

		function add_entries(){
			var begin_pos = $('#begin_pos').val();
			var url = "index.php?site=logview&sid={$sid}";
			table.processing(true);
			$('.btn_showmoreentrys').addClass('disabled');
		
		{literal}
			$.post(url, {begin_pos: begin_pos }, function(data){
		{/literal}
				data = $.parseHTML(data);
				$.each(data, function(key, itm){
					if (itm.className == 'wrapper') {
						var base = itm.children[2].children[0].children[0].children[0];
						var elems = base.children[0].children[1].children[1].children;
						var lastID = elems.length - 1;
						$.each(elems, function(uKey, uItm){
							console.log(uKey);
							table.row.add( [
								uItm.children[0].innerText,
								uItm.children[1].innerText,
								uItm.children[2].innerText,
								uItm.children[3].innerText,
								uItm.children[4].innerText
							] ).draw( false );
							if (uKey == lastID) {
								$('#begin_pos').val(base.children[0].children[0].value);
								$('.btn_showmoreentrys').removeClass('disabled');
								table.processing( false );
							}
						});
					}
				});
			});
		}
	});
</script>
<section class="content container-fluid">
	<div class="row">
		<div class="col-xs-12 col-xs-offset-0 col-sm-10 col-sm-offset-1 col-md-10 col-md-offset-1 col-lg-10 col-lg-offset-1">
			<div class="box box-primary">
				<div class="box-body" id="main_content">
					<input type="hidden" id="begin_pos" name="begin_pos" value="{$begin_pos}"/>
					<table class="table table-striped dt-responsive" id="traffic">
						<thead>
							<tr>
								<th width="20%">{$lang['date']}</th>
								<th width="5%">{$lang['level']}</th>
								<th width="10%">{$lang['type']}</th>
								<th width="10%">{$lang['serverid']}</th>
								<th width="55%">{$lang['message']}</th>
							</tr>
						</thead>
						<tbody>
					{if !empty($serverlog)}
						{foreach key=key item=value from=$serverlog}
							{if empty($smarty.post.type.error) AND empty($smarty.post.type.warning) AND empty($smarty.post.type.debug) AND empty($smarty.post.type.info) OR $smarty.post.type.error == $value['level'] OR $smarty.post.type.warning == $value['level'] OR $smarty.post.type.debug == $value['level'] OR $smarty.post.type.info == $value['level']}
								<tr>
									<td>{$value[0]}</td>
									<td>{$value[1]}</td>
									<td>{$value[2]}</td>
									<td>{$value[3]}</td>
									<td>{$value[4]}</td>
								</tr>
							{/if}
						{/foreach}
					{/if}
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</section>
{/if}