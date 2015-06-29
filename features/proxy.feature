Feature: proxy requests to multiple back ends

    Scenario: proxy requests to the back end

        Given there is a server on port "P1"
        And there is a server on port "P2"
        When the proxy is started with:
            | website_port | P1 |
            | numbers_port | P2 |
        Then GET requests are mapped as follows:
            | port | inurl      | outurl     |
            | P1   | /          | /          |
            | P2   | /numbers/x | /numbers/x |

