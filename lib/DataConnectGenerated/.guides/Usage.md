# Basic Usage

```dart
ExampleConnector.instance.InsertWedding().execute();
ExampleConnector.instance.UpdateWedding(updateWeddingVariables).execute();
ExampleConnector.instance.DeleteWedding(deleteWeddingVariables).execute();
ExampleConnector.instance.GetWedding(getWeddingVariables).execute();
ExampleConnector.instance.ListWeddings().execute();
ExampleConnector.instance.InsertArrangement(insertArrangementVariables).execute();
ExampleConnector.instance.UpdateArrangement(updateArrangementVariables).execute();
ExampleConnector.instance.DeleteArrangement(deleteArrangementVariables).execute();
ExampleConnector.instance.GetArrangement(getArrangementVariables).execute();
ExampleConnector.instance.ListArrangements().execute();

```

## Optional Fields

Some operations may have optional fields. In these cases, the Flutter SDK exposes a builder method, and will have to be set separately.

Optional fields can be discovered based on classes that have `Optional` object types.

Optional fields are configured through the generated builder for the remaining Data Connect operations. Always regenerate this directory after changing the Data Connect schema.
