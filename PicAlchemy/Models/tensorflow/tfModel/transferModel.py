import coremltools as ct

import tensorflow as tf
from typing import cast, List

# Use coremltools to convert Tensorflow model to CoreML model.
# Tensorflow model from https://www.kaggle.com/models/google/arbitrary-image-stylization-v1/tensorFlow1
# Input: content size is [1, W0, H0, 3], style is recommended to use [1, 256, 256, 3] as it's used in training
# Output: MLMultiArray with [1, W0, H0, 3] where W0, H0 equal input content size
def do_transfer():
    tf_model_path = "tfModel"
    coreml_model_path = "StyleTransfererModel.mlmodel"

    inputs: List[ct.TensorType] = cast(List[ct.TensorType], [
        ct.ImageType(
            name="placeholder", # content
            shape=(1, 512, 512, 3),
            scale=1 / 255.0,
            color_layout=ct.colorlayout.RGB
        ),
        ct.ImageType(
            name="placeholder_1", # style 
            shape=(1, 256, 256, 3),
            scale=1 / 255.0,
            color_layout=ct.colorlayout.RGB
        )
    ])

    mlmodel = ct.convert(
        tf_model_path,
        source="tensorflow",
        inputs=inputs,
        minimum_deployment_target=ct.target.iOS13
    )

    spec = mlmodel.get_spec()
    ct.utils.rename_feature(spec, 'placeholder', 'content')
    ct.utils.rename_feature(spec, 'placeholder_1', 'style')

    newModel.save(coreml_model_path)


def print_info():
    coreml_model_path = "StyleTransfererModel.mlmodel"
    coreMLModel = ct.models.MLModel(coreml_model_path)
    spec = coreMLModel.get_spec()
    for output in spec.description.output:
        print(f"Output Name: {output.name}")
        print(f"Output Type: {output.type.WhichOneof('Type')}")

        if output.type.HasField('multiArrayType'):
            print(f"Output Shape (MultiArray): {output.type.multiArrayType.shape}")
        elif output.type.HasField('imageType'):
            print(f"Output Type: Image with Color Layout: {output.type.imageType.colorLayout}")
        elif output.type.HasField('tensorType'):
            print(f"Output Type: Tensor")
            print(f"Tensor Shape: {output.type.tensorType.shape}")


if __name__ == '__main__':
    # do_transfer()
    print_info()

