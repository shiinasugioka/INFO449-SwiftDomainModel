struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    
    let conversion_rates: [String : Double] = [
        "USD" : 1.0,
        "GBP" : 0.5,
        "EUR" : 1.5,
        "CAN" : 1.25
    ]
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    // takes a currency name as a parameter
    // returns a new Money that contains the converted amount
    func convert(_ targetCurr: String) -> Money {
        if (!isValidCurrency(targetCurr: targetCurr)) { return self }
        
        let rate = conversion_rates[self.currency]!
        let targetRate = conversion_rates[targetCurr]!
        
        let convertedAmount = Int(Double(amount) / rate * targetRate)
        
        return Money(amount: convertedAmount, currency: targetCurr)
    }
    
    private func isValidCurrency(targetCurr: String) -> Bool {
        let currency_list = ["USD", "GBP", "EUR", "CAN"]
        return currency_list.contains(targetCurr)
    }
    
    func add(_ other: Money) -> Money {
        let targetCurr = other.currency
        
        let this = self.convert(targetCurr).amount
        
        return Money(amount: this + other.amount, currency: targetCurr)
        
        // return curr shuold be other.curr
        
    }
    
    func subtract(_ other: Money) -> Money {
        let targetCurr = other.currency
        
        let this = self.convert("targetCurr").amount
        
        return Money(amount: this - other.amount, currency: targetCurr)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    var title: String
    var type: JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ hoursWorked: Int) -> Int {
        switch type {
        case .Hourly(let hourlyWage):
            return Int(hourlyWage * Double(hoursWorked))
        case .Salary(let annualWage):
            return Int(annualWage)
        }
    }
    
    func raise(byAmount: Double) {
        switch type {
        case .Hourly(let hourlyWage):
            let newHourlyWage = hourlyWage + byAmount
            type = JobType.Hourly(newHourlyWage)
        case .Salary(let annualWage):
            let newAnnualWage = annualWage + UInt(byAmount)
            type = JobType.Salary(newAnnualWage)
        }
    }
    
    func raise(byPercent: Double) {
        switch type {
        case .Hourly(let hourlyWage):
            let newHourlyWage = hourlyWage + hourlyWage * byPercent
            type = JobType.Hourly(newHourlyWage)
        case .Salary(let annualWage):
            let newAnnualWage = Double(annualWage) + Double(annualWage) * byPercent
            type = JobType.Salary(UInt(newAnnualWage))
        }
    }
    
    func convert() {
        switch type {
        case .Hourly(let hourlyWage):
            let annualWage = Int((hourlyWage * 2000).rounded(.up))
            type = JobType.Salary(UInt(annualWage))
        case .Salary:
            break
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String?
    var lastName: String?
    var age: Int
    var job: Job? {
        didSet {
            if (age < 16) {
                job = nil
            }
        }
    }
    var spouse: Person? {
        didSet {
            if (age < 16) {
                spouse = nil
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    init(firstName: String, age: Int) {
        self.firstName = firstName
        self.age = age
    }
    
    init(lastName: String, age: Int) {
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String {
        // [Person: firstName: Ted lastName: Neward age: 45 job: Salary(1000) spouse: Charlotte]
        
        var res = "[Person:"
        
        res += " firstName:\(firstName ?? "nil")"
        res += " lastName:\(lastName ?? "nil")"
        res += " age:\(self.age)"
        
        if let job = job {
            res += " job: \(job.type)"
        } else {
            res += " job:nil"
        }
        
        if let spouse = spouse {
            res += " spouse: \(spouse.firstName ?? "nil")"
        } else {
            res += " spouse:nil"
        }
        
        res += "]"
        
        return res
    }
    
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]
    
    init(spouse1: Person, spouse2: Person) {
        if (spouse1.spouse == nil && spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            
            members = [spouse1, spouse2]
        } else {
            members = []
        }
    }
    
    func haveChild(_ child: Person) -> Bool {
        if (self.members.contains(where: { $0.age < 21 })) {
            return false
        }
        
        members.append(child)
        return true
    }
    
    func householdIncome() -> Int {
        var totalIncome = 0
        for member in members {
            if let job = member.job {
                switch job.type {
                case .Hourly(let hourlyWage):
                    totalIncome += Int(hourlyWage * 2000)
                case .Salary(let annualWage):
                    totalIncome += Int(annualWage)
                }
            }
        }
        
        return totalIncome
    }
}
