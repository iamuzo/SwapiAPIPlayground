import UIKit

struct Person: Decodable {
    var name: String
    var films: [URL]
}

struct Film: Decodable {
    var title: String
    var release_date: String
    var opening_crawl: String
}

class SwapiService {
    private static let baseURL = URL(string: "https://swapi.co/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        
        guard let baseURL = baseURL else { return completion(nil) }

        let peopleString = "people/"
        let personString = "\(id)"
        
        let finalString = peopleString + personString
        let finalURL = baseURL.appendingPathComponent(finalString)
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, requestResponse, requestError) in
            
            if let error = requestError {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
            if let response = requestResponse {
                print(response)
            }
            
            guard let data = data else { return completion(nil) }
            
            do {
                let finalResult = try JSONDecoder().decode(Person.self, from: data)
                completion(finalResult)
            } catch {
                print("unable to decode to decode: \(error.localizedDescription)")
                return completion(nil)
            }
        }.resume()
            
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error, error.localizedDescription)
            }
            
            guard let data = data else { return completion(nil) }
            
            do {
                let decodedData = try JSONDecoder().decode(Film.self, from: data)
                completion(decodedData)
            } catch {
                print("unable to decode to decode: \(error.localizedDescription)")
                return completion(nil)
            }
        }.resume()
    }
}

SwapiService.fetchPerson(id: 1) { (person) in
    if let person = person {
        print(person.films)
        let films = person.films
        for film in films {
            let url2Pass = film
            SwapiService.fetchFilm(url: url2Pass) { (film) in
                if let film = film {
                    print(film)
                }
            }
        }
    }
}


let url2Pass = URL(string: "https://swapi.co/api/films/2/")
SwapiService.fetchFilm(url: url2Pass!) { (film) in
    if let film = film {
        print(film)
    }
}
