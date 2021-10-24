//
//  BackCode.swift
//  myToDoList
//
//  Created by Максим Сидорин on 10.10.2021.
//

import Foundation

class PrototypeVector {
        var value: String
        var sizeCluster : Int

    init (lvalue : String){
        value = lvalue
        sizeCluster = 0
    }
}

class FeatureVector {
    let NO_CLUSTER = -1
    var clusterId : Int
    var value : String
    
    init (clusterId: Int, value: String){
        self.value = value
        self.clusterId = clusterId
    }
}

class ART1Model {
    var features: Array<FeatureVector>
    var prototypes: Array<PrototypeVector>
    
    init (features: Array<FeatureVector>, prototypes: Array<PrototypeVector>) {
        self.features = features
        self.prototypes = prototypes
        
    }
}

class ART1 {

    var params = ART1Model(features: [], prototypes: [])

    func start(
            maxCluster: Int,
            p: Float,
            d: Int,
            betta: Int,
            features: String
    ) -> String {

        initFeatures(features: features)
        var stopFlag = false

        params.features.forEach{ str in
            print(str.value)
            
        }

        while (!stopFlag && params.prototypes.count < maxCluster) {
            params.features.forEach { feature in
                
                var isNewClusterFlag = true

                for index in 0..<params.prototypes.count {
                    let prototype = params.prototypes[index]

                    if (similarityCheck(prototypeVector: prototype.value, featureVector: feature.value, betta: betta, d: d)) {
                        if (mindfulnessCheck(prototypeVector: prototype.value, featureVector: feature.value, p: p)) {
                            feature.clusterId = index
                            prototype.value = bitAnd(prototypeVector: prototype.value, featureVector: feature.value)
                            stopFlag = false
                            isNewClusterFlag = false
                            break
                        } else {
                            stopFlag = true
                        }
                    } else {
                        stopFlag = true
                    }
                }

                if (isNewClusterFlag) {
                    params.prototypes += ([PrototypeVector(lvalue: feature.value)])
                    feature.clusterId = params.prototypes.count - 1
                    stopFlag = false
                } else {
                    stopFlag = true
                }
        }
        }
        calcSizeClusters(prototypes: params.prototypes, features: params.features)
//       // fillEntries(entries)
        return showClusters()
}
        
    func initFeatures(features: String) {
        var featuresList = Array<FeatureVector>()
        features.components(separatedBy: " ").forEach{str in
            featuresList.append(FeatureVector(clusterId: -1, value: str))
        }
        params = ART1Model(features: featuresList, prototypes: [])
    }

    func bitAnd(prototypeVector: String, featureVector: String) -> String {
        var resultVector = ""

        for index in 0...prototypeVector.count - 1
        {
            resultVector += String(prototypeVector.character(index).wholeNumberValue! & featureVector.character(index).wholeNumberValue!)
        }
        return resultVector
    }

    func significanceVector(vector: String) -> Int {
        return vector.filter {$0 == "1"}.count
    }

    func similarityCheck(prototypeVector: String, featureVector: String, betta: Int, d: Int) -> Bool {
        let leftPart = Float(significanceVector( vector: bitAnd(prototypeVector: prototypeVector, featureVector: featureVector)) ) / Float(betta + significanceVector(vector: prototypeVector))
        let rightPart = Float(significanceVector(vector: featureVector))  / Float(betta + d)
        return  leftPart > rightPart
    }

    func mindfulnessCheck(prototypeVector: String, featureVector: String, p: Float) -> Bool {
        let leftPart = Float(significanceVector(vector: bitAnd(prototypeVector: prototypeVector, featureVector: featureVector))) / Float(significanceVector(vector: featureVector))
        return leftPart < p
    }

    //region ==================== Internal ====================

    func calcSizeClusters(prototypes: Array<PrototypeVector>, features: Array<FeatureVector>) {
        features.forEach {index in
            prototypes[index.clusterId].sizeCluster += 1
        }
    }

//    func fillEntries(entries: MutableList<PieEntry>) {
//        params.prototypes.forEachIndexed { index, prototype ->
//            if (prototype.sizeCluster != 0) {
//                entries.add(PieEntry(
//                        prototype.sizeCluster.toFloat() / params.features.size)
//
//            }
//        }
//    }

    func showClusters  () -> String {
       var clustersString = ""
        var index = 1
        params.prototypes.forEach {prototype in
            if (prototype.sizeCluster != 0)
            {
                clustersString += "\(index) \(prototype.value) - \(prototype.sizeCluster)\n"
                index += 1
            }
        }
      return clustersString
    }
}

