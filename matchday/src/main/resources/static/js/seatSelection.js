$(document).ready(function() {
    let selectedSection = null;
    const matchid = $('#matchid').val();

    function highlightSection(section) {
        selectedSection = section;
        $('.overlay div').css('background-color', 'transparent');
        const sectionDiv = $('.' + section);
        if (sectionDiv.length) {
            sectionDiv.css('background-color', getSectionColor(section));
        }
        $('.list-group-item, .section-link').removeClass('active');
        const activeLink = $('[data-section="' + section + '"]');
        if (activeLink.length) {
            activeLink.addClass('active');
        }
    }

    function getSectionColor(section) {
        switch (section) {
            case 'north':
                return 'rgba(255, 0, 0, 0.5)';
            case 'west':
                return 'rgba(0, 0, 255, 0.5)';
            case 'east':
                return 'rgba(0, 255, 0, 0.5)';
            case 'south':
                return 'rgba(255, 255, 0, 0.5)';
            default:
                return 'transparent';
        }
    }

    $('.section-link').click(function(event) {
        event.preventDefault();
        highlightSection($(this).data('section'));
    });

    $('#autoAssign').click(function() {
        const sections = ['north', 'west', 'east', 'south'];
        const randomSection = sections[Math.floor(Math.random() * sections.length)];
        highlightSection(randomSection);
    });

    $('#selectSeats').click(function() {
        if (selectedSection) {
            const url = `/tickets/seatmap?matchid=${matchid}&section=${selectedSection}`;
            window.location.href = url;
        } else {
            alert('구역을 선택해주세요.');
        }
    });
});
