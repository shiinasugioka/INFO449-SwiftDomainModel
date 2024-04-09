import XCTest
@testable import DomainModel

class JobTests: XCTestCase {
  
    func testCreateSalaryJob() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)
        XCTAssert(job.calculateIncome(100) == 1000)
        // Salary jobs pay the same no matter how many hours you work
    }

    func testCreateHourlyJob() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)
        XCTAssert(job.calculateIncome(20) == 300)
    }

    func testSalariedRaise() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)

        job.raise(byAmount: 1000)
        XCTAssert(job.calculateIncome(50) == 2000)

        job.raise(byPercent: 0.1)
        XCTAssert(job.calculateIncome(50) == 2200)
    }

    func testHourlyRaise() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)

        job.raise(byAmount: 1.0)
        XCTAssert(job.calculateIncome(10) == 160)

        job.raise(byPercent: 1.0) // Nice raise, bruh
        XCTAssert(job.calculateIncome(10) == 320)
    }
    
    // extra credit
    func testHourlyToSalaryConversion() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        job.convert()
        
        switch job.type {
        case .Salary(let annualWage):
            XCTAssert(annualWage == 30000)
        case .Hourly:
            break
        }
    }

    func testAlreadySalaryConversion() {
        let job = Job(title: "Manager", type: Job.JobType.Salary(80000))
        job.convert()
        
        switch job.type {
        case .Salary(let annualWage):
            XCTAssert(annualWage == 80000)
        case .Hourly:
            break
        }
    }

  
    static var allTests = [
        ("testCreateSalaryJob", testCreateSalaryJob),
        ("testCreateHourlyJob", testCreateHourlyJob),
        ("testSalariedRaise", testSalariedRaise),
        ("testHourlyRaise", testHourlyRaise),
        ("testHourlyToSalaryConversion", testHourlyToSalaryConversion),
        ("testAlreadySalaryConversion", testAlreadySalaryConversion)
    ]
}
