# set state
$(document).ready ->
  checked_ids = $.session.get('checked_ids')
  if($.isEmptyObject(checked_ids) == false)
    console.log(checked_ids)
    listings_to_display = new Array()
    $(checked_ids.split(',')).each((x, id) ->
      $('#'+id).attr('checked', true)
      $('#'+id+'_services').show()
    )
    $('.location_listing').hide()
    $('.location_listing').each((a, listing) -> 
      listing_id_match = true
      listing_tags = listing.getAttribute('data-tags').split(' ')
      $.each(checked_ids.split(','), (b, id) -> 
        if listing_tags.indexOf(id) == -1 
          listing_id_match = false
          # only need one mismatch - looping again might override the false value if the next id is a match
          return
      )
      if listing_id_match == true
        listings_to_display.push(listing)
        $('#'+listing.getAttribute('id')).show() 
    )
    if listings_to_display.length == 0
      $("#results_count").html('There are no results that match your search criteria')
    else if listings_to_display.length == 1
      $("#results_count").html(listings_to_display.length + ' result')
    else
      $("#results_count").html(listings_to_display.length + ' results')

# clear filters
$ -> 
  $('#clear_filters').click -> 
    $(':checkbox').attr('checked', false)
    $('.services').hide()
    $.session.delete('checked_ids')
    listings_to_display = new Array()
    $('.location_listing').each((a, listing) -> 
      listings_to_display.push(listing)
      $('#'+listing.getAttribute('id')).show()
    )
    if(listings_to_display.length == 0)
      $("#results_count").html('There are no results that match your search')
    else if(listings_to_display.length == 1)
      $("#results_count").html(listings_to_display.length + ' result')
    else
      $("#results_count").html(listings_to_display.length + ' results')


# filter results
$ -> 
  $(':checkbox').click -> 
    checked_ids = new Array()
    listings_to_display = new Array()
    $(':checkbox').each((i, value) ->  
      if $('#' + value.getAttribute('id')).is(':checked')
        $('#' + value.getAttribute('id') + '_services').show()
        checked_ids.push(value.getAttribute('id'))
      else 
        $('#' + value.getAttribute('id') + '_services').hide()
        $('#' + value.getAttribute('id') + '_services :checkbox').attr('checked', false)
    )
    $.unique(checked_ids)
    $.session.set('checked_ids', checked_ids)
    
    
    if checked_ids.length == 0
      $('.location_listing').each((a, listing) -> 
        listings_to_display.push(listing)
        $('#'+listing.getAttribute('id')).show()
      )  
    else 
      $('.location_listing').hide()
      $('.location_listing').each((a, listing) -> 
        listing_id_match = true
        listing_tags = listing.getAttribute('data-tags').split(' ')
        $.each(checked_ids, (b, id) -> 
          if listing_tags.indexOf(id) == -1 
            listing_id_match = false
            # only need one mismatch - looping again might override the false value if the next id is a match
            return
        )
        if listing_id_match == true
          listings_to_display.push(listing)
          $('#'+listing.getAttribute('id')).show() 
      )
    if listings_to_display.length == 0
      $("#results_count").html('There are no results that match your search criteria')
    else if listings_to_display.length == 1
      $("#results_count").html(listings_to_display.length + ' result')
    else
      $("#results_count").html(listings_to_display.length + ' results')