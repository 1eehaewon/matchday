document.addEventListener('DOMContentLoaded', () => {
    console.log("DOMContentLoaded event fired"); // 디버깅 메시지 추가

    let selectedSection = null;

    function highlightSection(section) {
        console.log("highlightSection called with section:", section); // 디버깅 메시지 추가
        selectedSection = section; // 선택된 구역 저장
        // 모든 구역의 배경 색상 초기화
        document.querySelectorAll('.overlay div').forEach(div => {
            div.style.backgroundColor = 'transparent';
        });
        // 선택된 구역에 색상 적용
        const sectionDiv = document.querySelector(`.${section}`);
        if (sectionDiv) {
            sectionDiv.style.backgroundColor = getSectionColor(section);
            console.log(`Section ${section} colored with ${getSectionColor(section)}`); // 디버깅 메시지 추가
        } else {
            console.log(`Section ${section} not found`); // 디버깅 메시지 추가
        }

        // 모든 목록 항목의 활성 상태 초기화
        document.querySelectorAll('.list-group-item, .section-link').forEach(el => {
            el.classList.remove('active');
        });
        // 선택된 목록 항목 활성화
        const activeLink = document.querySelector(`[data-section="${section}"]`);
        if (activeLink) {
            activeLink.classList.add('active');
            console.log(`Link for section ${section} is now active`); // 디버깅 메시지 추가
        } else {
            console.log(`Link for section ${section} not found`); // 디버깅 메시지 추가
        }
    }

    function getSectionColor(section) {
        switch (section) {
            case 'north':
                return 'rgba(255, 0, 0, 0.5)'; // 빨강색 반투명
            case 'west':
                return 'rgba(0, 0, 255, 0.5)'; // 파랑색 반투명
            case 'east':
                return 'rgba(0, 255, 0, 0.5)'; // 초록색 반투명
            case 'south':
                return 'rgba(255, 255, 0, 0.5)'; // 노랑색 반투명
            default:
                return 'transparent';
        }
    }

    function getRandomSection() {
        const sections = ['north', 'west', 'east', 'south'];
        const randomIndex = Math.floor(Math.random() * sections.length);
        return sections[randomIndex];
    }

    document.querySelectorAll('.section-link').forEach(item => {
        item.addEventListener('click', (event) => {
            event.preventDefault();
            console.log("Section link clicked:", event.currentTarget.getAttribute('data-section')); // 디버깅 메시지 추가
            highlightSection(event.currentTarget.getAttribute('data-section'));
        });
    });

    document.querySelector('#autoAssign').addEventListener('click', () => {
        const randomSection = getRandomSection();
        console.log("Random section selected:", randomSection); // 디버깅 메시지 추가
        highlightSection(randomSection);
    });

    document.querySelector('#selectSeats').addEventListener('click', () => {
        if (selectedSection) {
            const url = `/selectSeats?section=${selectedSection}`;
            console.log("Navigating to:", url); // 디버깅 메시지 추가
            window.location.href = url;
        } else {
            alert("구역을 선택해주세요.");
        }
    });
});
