//
//  HistoryRecordView.swift
//  CaptuOCR
//
//  Created by Carlos Andres Chaguendo Sanchez on 5/03/21.
//

import SwiftUI
import AppKit

protocol HistoryRecordViewDelegate {
    
    func historyRecordView(didRemove record: HistoryRecord)
    
}

struct HistoryRecordView: View {
    
    @State var record: HistoryRecord!
    
    @State var df: DateFormatter!
    
    var delegate: HistoryRecordViewDelegate!
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .leading, spacing: 6 ) {
            
                HStack {
                    Text(df.string(from: record.date))
                        .font(.title2)
                    Spacer()
                    
                    if !record.isInvalidated {
                        Button(action: removeRecord, label: {
                            Text("Remove")
                        })
                    }
                }
                
                if let image = NSImage(data: record.imageBase64) {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: reader.size.width, height: min(image.size.height, 250.0 ), alignment: .leading)
    
                }
            
                TextEditor(text: .constant(record.text))
            }
        }.padding()
        .frame(width: 400, height: nil, alignment: .center)
    }
    
    func removeRecord() {
        HistoryService.remove(record)
        delegate.historyRecordView(didRemove: record)
    }
}

struct HistoryRecordView_Previews: PreviewProvider {
    
    private static let df: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .short
        return df
    }()
    
    static var previews: some View {
        HistoryRecordView(record: HistoryRecord(), df: df)
    }
}
