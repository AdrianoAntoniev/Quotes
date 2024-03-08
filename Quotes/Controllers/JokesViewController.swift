//
//  JokesViewController.swift
//  Jokes
//
//  Created by Adriano Rodrigues Vieira on 04/02/24.
//

import UIKit
import SkeletonView

final class JokesViewController: UIViewController {
    private let aView = JokesView()
    var jokeWasFetched = false

    override func loadView() {
        super.loadView()
        view = aView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setup()
    }

    private func setup() {
        aView.button.setTitle("Get Joke!", for: .normal)
        aView.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        aView.setupLabel.text = "No Joke..."
    }

    @objc private func buttonTapped() {
        jokeWasFetched = false
        aView.setupLabel.showSkeleton()
        aView.punchlineLabel.isHidden = false
        aView.punchlineLabel.showSkeleton()
        aView.typeLabel.showSkeleton()

        let urlPath = "https://official-joke-api.appspot.com/jokes/random"

        guard let url = URL(string: urlPath) else { return }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request, printingJson: true) { data, response, error in
            if let error {
                Task {
                    await self.fillLabel(with: "Ops! Something wrong occurs: \(error.localizedDescription)")
                    return
                }
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 429 {
                Task {
                    await self.fillLabel(with: "Too many requests. Try again later")
                    return
                }
            }

            if let data {
                do {
                    let joke = try JSONDecoder().decode(JokeModel.self, from: data)

                    Task {
                        await self.fillLabels(with: joke)
                    }
                } catch {
                    Task {
                        await self.fillLabel(with: "Ops! Something wrong occurs: \(error.localizedDescription)")
                    }
                }
            } else {
                Task {
                    await self.fillLabel(with: "Ops! Something wrong occurred...")
                }
            }
        }.resume()
    }

    private func fillLabels(with joke: JokeModel) {
        guard !jokeWasFetched else { return }

        guard
            let setup = joke.setup, !setup.isEmpty,
            let punchline = joke.punchline,
            let type = joke.type
        else { return }

        jokeWasFetched = true

        DispatchQueue.main.async {
            self.aView.setupLabel.hideSkeleton(transition: .crossDissolve(0.25))
            self.aView.punchlineLabel.hideSkeleton(transition: .crossDissolve(0.25))
            self.aView.typeLabel.hideSkeleton(transition: .crossDissolve(0.25))

            self.aView.setupLabel.text = "Setup: \(setup)"

            if !punchline.isEmpty {
                self.aView.punchlineLabel.text = "Punchline: \(punchline)"
            } else {
                self.aView.punchlineLabel.isHidden = true
            }

            if !type.isEmpty {
                self.aView.typeLabel.text = "Type of joke: \(type.capitalized)"
            } else {
                self.aView.typeLabel.isHidden = true
            }
        }
    }

    private func fillLabel(with error: String) {
        DispatchQueue.main.async {
            self.aView.setupLabel.hideSkeleton(transition: .crossDissolve(0.25))
            self.aView.punchlineLabel.hideSkeleton(transition: .crossDissolve(0.25))

            self.aView.setupLabel.text = error

            self.aView.punchlineLabel.isHidden = true
            self.aView.typeLabel.isHidden = true
        }
    }
}

