//
//  AnimalWidget.swift
//  AnimalWidget
//
//  Created by Tihomir RAdeff on 27.08.22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), imageName: "", imageUrl: "placeholder")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), imageName: "", imageUrl: "placeholder")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let imageNames = [
            "Pig",
            "Cow",
            "Owl",
            "Chicken",
            "Sheep"
        ]
        
        let imageUrls = [
            "https://radefffactory.com/Documents/pig.png",
            "https://radefffactory.com/Documents/cow.png",
            "https://radefffactory.com/Documents/owl.png",
            "https://radefffactory.com/Documents/chicken.png",
            "https://radefffactory.com/Documents/sheep.png"
        ]
        
        var animals = [Animals]()
        
        for i in 0...4 {
            let animal = Animals(name: imageNames[i], image: imageUrls[i])
            animals.append(animal)
        }
        
        animals.shuffle()

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for secondOffset in 0 ..< 50 {
            
            let value = secondOffset / 10 //change every 10 seconds
            
            let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, imageName: animals[value].name, imageUrl: animals[value].image)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct Animals {
    
    let name: String
    let image: String
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    
    let imageName: String
    let imageUrl: String
}

struct NetworkImage: View {
    
    let url: URL?
    
    var body: some View {
        Group {
            
            if let url = url, let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image("placeholder")
                    .resizable()
                    .scaledToFill()
            }
            
        }
    }
    
}

struct AnimalWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color("background").edgesIgnoringSafeArea(.all)
            
            NetworkImage(url: URL(string: entry.imageUrl))
            
            VStack {
                Spacer()
                
                Text(entry.imageName)
                    .padding(.all, 10)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color("backgroundText"))
            }
        }
    }
}

@main
struct AnimalWidget: Widget {
    let kind: String = "AnimalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AnimalWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Animal Widget")
        .description("This is an animal widget.")
        .supportedFamilies([.systemSmall, .systemLarge])
    }
}

struct AnimalWidget_Previews: PreviewProvider {
    static var previews: some View {
        AnimalWidgetEntryView(entry: SimpleEntry(date: Date(), imageName: "", imageUrl: "placeholder"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
