//
//  QuotesViewController.swift
//  Quotes
//
//  Created by Adriano Rodrigues Vieira on 04/02/24.
//

import UIKit
import SkeletonView

final class QuotesViewController: UIViewController {
    private let aView = QuotesView()
    var quotedWasFetched = false

    private let apiKey = "6BsMKVg7d0pN6KpWdomblFMLZWkvMVRBDF7N16G4"

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
        aView.button.setTitle("Get quote!", for: .normal)
        aView.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        aView.label.text = "No quote..."
    }

    @objc private func buttonTapped() {
        quotedWasFetched = false
        aView.label.showSkeleton()

        let urlPath = "https://quotes.rest/qod?api_key=\(apiKey)"

        guard let url = URL(string: urlPath) else { return }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request, printingJson: true) { data, response, error in
            if let error {
                Task {
                    await self.fillLabel(withText: "Ops! Something wrong occurs: \(error.localizedDescription)")
                    return
                }
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 429 {
                Task {
                    await self.fillLabel(withText: "Too many requests. Try again later")
                    return
                }
            }

            if let data {
                do {
                    let decoded = try JSONDecoder().decode(QuotesModel.self, from: data)                    

                    Task {
                        await self.fillLabel(withText: decoded.contents?.quotes?.first?.quote ?? "Error fetching quote")
                    }
                } catch {
                    Task {
                        await self.fillLabel(withText: "Ops! Something wrong occurs: \(error.localizedDescription)")
                    }
                }
            } else {
                Task {
                    await self.fillLabel(withText: "Ops! Something wrong occurred...")
                }
            }
        }.resume()
    }

    private func fillLabel(withText text: String) {
        guard !quotedWasFetched, !text.isEmpty else { return }

        quotedWasFetched = true

        DispatchQueue.main.async {
            self.aView.label.hideSkeleton(transition: .crossDissolve(0.25))
            self.aView.label.text = text
        }
    }
}

