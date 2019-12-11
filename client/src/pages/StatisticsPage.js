import React, { useState, useEffect } from "react"
import { Form, Button, Alert, Table, ListGroup, Nav, Container, Row, Col } from 'react-bootstrap';

export const StatisticsPage = () => {
  const [error, setError] = useState(null)
  const [urlStats, setUrlStats] = useState(null)
  const [globalStats, setGlobalStats] = useState(null)
  const [page, setPage] = useState(0)

  const getStatsByUrl = (page) => {
    fetch(`http://localhost:4567/api/stats-by-url/${page ? page : ""}`,
      {
        mode: 'cors',
        headers: new Headers({
        'Accept': 'application/json',
        'Content-Type': 'application/json'
        })
      })
      .then(data => data.json())
      .then(response => {
        if (!response.data) {
          throw new Error("Error with getting stats")
        }
        
        setUrlStats(response.data)
        setPage(response.page)
      }).catch(error => {
        setError(error.message)
      })
  }

  const getGlobalStats = () => {
    fetch("http://localhost:4567/api/global-statistics",
      {
        mode: 'cors',
        headers: new Headers({
        'Accept': 'application/json',
        'Content-Type': 'application/json'
        })
      })
      .then(data => data.json())
      .then(response => {
        if (!response.data) {
          throw new Error("Error with getting global stats")
        }
        
        setGlobalStats(response.data)
      }).catch(error => {
        setError(error.message)
      })
  }

  useEffect(() => {
    getStatsByUrl()
    getGlobalStats()

  }, [])

  const setPaginate = () => {
    getStatsByUrl(page)
  }

  return (
    <div>
      <Nav>
        <Nav.Item>
          <Nav.Link href="#/">Back to the main page</Nav.Link>
        </Nav.Item>
      </Nav>

      {globalStats && (
        <div className="mt-5">
          <Container>
            <Row>
              <Col>
                <h3>Global statistic</h3>
              </Col>
            </Row>
            <Row>
              <Col>
                <h5>Total redirections: {globalStats.redirections["total-redirections"]}</h5>
              </Col>
              <Col>
                <h5>Unic redirections: {globalStats.redirections["unic-redirections"]}</h5>
              </Col>
            </Row>
          </Container>
          <div></div>
          <h4>Users by countries (%)</h4>
          <ListGroup>
            {Object.entries(globalStats.countries).map(([country, value]) => {
              return (
                <ListGroup.Item>{country}: {value} %</ListGroup.Item>
              )
            })}
          </ListGroup>
        </div>
        
      )}

      <div className="mt-5">
        <h4>Stats by URL</h4>
        {urlStats && (
          <Table striped bordered hover size="sm" className="mt-3">
            <thead>
              <tr>
                <th>Redirects</th>
                <th>Unic redirects</th>
                <th>Full url</th>
                <th>Short url</th>
              </tr>
            </thead>

            <tbody>
              {Object.keys(urlStats).map(key => {
                const { long_url, short_url, r, u } = urlStats[key]
                return (
                  <tr>
                    <td class="w-10">{r}</td>
                    <td class="w-10">{u}</td>
                    <td class="w-60">{long_url}</td>
                    <td class="w-20">{short_url}</td>
                  </tr>
                )
              })}
            </tbody>
          </Table>
        )}
      </div>

      {page != 0 && <Button onClick={setPaginate}>Next records</Button>}



      {error && <Alert variant="danger">{error}</Alert>}
    </div>
  )
}
